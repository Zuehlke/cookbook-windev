#
# Cookbook Name:: windev
# Recipe:: choco_packages
#
# Copyright (c) 2014-2018 Zühlke, All Rights Reserved.

include_recipe 'windev::depot'

::Chef::Recipe.send(:include, Windows::Helper)

choco_packages=node.fetch('choco_packages',[])

choco_packages.each do |pkg|
  if pkg["name"]
    pkg_source=pkg.fetch("source","")
    pkg_options=pkg.fetch("options","")
    pkg_version=pkg.fetch("version","")
    chocolatey_package pkg["name"] do
      version pkg_version unless pkg_version.empty?
      source pkg_source unless pkg_source.empty?
      options pkg_options unless pkg_options.empty?
      action :install
    end
  end
end
