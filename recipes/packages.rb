#
# Cookbook Name:: windev
# Recipe:: packages
#
# Copyright (c) 2014 Zühlke, All Rights Reserved.

include_recipe 'windows::reboot_handler'
include_recipe 'windev::depot'

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
      if pkg["installer"]
        installer= ::File.join(node["software_depot"],pkg['installer'])
      else
        installer= ::File.join(node["software_depot"],pkg['save_as'])
      end
    else
      installer= ::File.join(node["software_depot"],pkg['installer'])
    end

    windows_package pkg['name'] do
      source installer
      if pkg['type'] 
        installer_type pkg['type'].to_sym
      end
      options pkg['options']
      version pkg['version']
      success_codes [0,42,127,3010]
      timeout pkg.fetch('timeout',600)
      action :install
    end
  end
end

node.fetch('zip_packages',[]).each do |pkg|
  version=::File.expand_path("#{pkg['unpack']}/#{pkg['version']}.version")
  unless ::File.exists?(version)
    if pkg["source"]
      windev_cache_package pkg["save_as"] do
        source pkg["source"]
        depot node['software_depot']
      end
      installer=::File.join(node["software_depot"],pkg['save_as'])
    else
      installer=::File.join(node["software_depot"],pkg['archive'])
    end
    directory pkg['unpack'] do
      action :delete
      recursive true
    end
    windows_zipfile pkg['unpack'] do
      source installer
      action :unzip
    end
    file version do 
      action :create
    end
  end
end

choco_packages=node.fetch('choco_packages',[])

unless choco_packages.empty?
  include_recipe 'chocolatey::default'
end

choco_packages.each do |pkg|
  if pkg["name"]
    pkg_source=pkg.fetch("source","")
    pkg_args=pkg.fetch("args","")
    pkg_version=pkg.fetch("version","")
    chocolatey pkg["name"] do
      version pkg_version unless pkg_version.empty?
      source pkg_source unless pkg_source.empty?
      args pkg_args unless pkg_args.empty?
      action :install
    end
  end
end