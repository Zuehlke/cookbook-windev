#
# Cookbook Name:: windev
# Recipe:: zip_packages
#
# Copyright (c) 2014-2018 Zühlke, All Rights Reserved.

::Chef::Recipe.send(:include, Windows::Helper)

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
