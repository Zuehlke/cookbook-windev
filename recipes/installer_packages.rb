#
# Cookbook Name:: windev
# Recipe:: installer_packages
#
# Copyright (c) 2014-2018 Zühlke, All Rights Reserved.

::Chef::Recipe.send(:include, Windows::Helper)

node.fetch('installer_packages',[]).each do |pkg|
  unless is_package_installed?(pkg['name']) && installed_packages[pkg['name']][:version] == pkg['version']
    if pkg["source"]
      windev_cache_package pkg["save_as"] do
        source pkg["source"]
        depot node['software_depot']
      end
      if pkg["unpack"]
        unpackPath = File.join(node["software_depot"],pkg['unpack'])
        directory unpackPath do
          action :delete
          recursive true
        end
        windows_zipfile unpackPath do
          source ::File.join(node["software_depot"],pkg['save_as'])
          action :unzip
        end
      end
    end
    if pkg["installer"]
      installer= ::File.join(node["software_depot"],pkg['installer'])
    else
      installer= ::File.join(node["software_depot"],pkg['save_as'])
    end

    ruby_block "#{installer} exists" do
      block do
        raise "Installer #{File.expand_path(installer)} not found" unless File.exist?(File.expand_path(installer))
      end
      action :run
    end

    windows_package pkg['name'] do
      source File.expand_path(installer)
      installer_type pkg['type'].to_sym if pkg['type']
      options pkg['options']
      version pkg['version']
      timeout pkg.fetch('timeout',600)
      returns [0,3010] + pkg.fetch('exit_codes', [])
      action :install
    end
  end
end
