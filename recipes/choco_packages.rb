#
# Cookbook Name:: windev
# Recipe:: choco_packages
#
# Copyright (c) 2014-2018 Zühlke, All Rights Reserved.

include_recipe 'windev::depot'

::Chef::Recipe.send(:include, Windows::Helper)

choco_packages=node.fetch('choco_packages',[])
choco_packages=node.fetch('choco_packages',[])

unless choco_packages.empty?
  include_recipe 'chocolatey::default'
end
choco_packages.each do |pkg|
  if pkg["name"]
    pkg_source=pkg.fetch("source","")
    pkg_options=pkg.fetch("options","")
    pkg_version=pkg.fetch("version","")
    pkg_params=pkg.fetch("params","")

    if !pkg_params.empty?
      pkg_options<<" --parameters #{pkg_params}"
    end
    chocolatey_package pkg["name"] do
      version pkg_version unless pkg_version.empty?
      source pkg_source unless pkg_source.empty?
      options pkg_options unless pkg_options.empty?
      returns [0,3010] + pkg.fetch('exit_codes', [])
      action :install
    end
  end
end
