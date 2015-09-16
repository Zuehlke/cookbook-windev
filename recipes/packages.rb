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
      windev_cache_package pkg["save_as"] do
        source pkg["source"]
        depot node['software_depot']
        only_if pkg["source"]
      end
    
    installer= ::File.join(node["software_depot"],pkg.fetch('installer',""))
    if pkg['save_as']
      installer= ::File.join(node["software_depot"],pkg['save_as'])
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