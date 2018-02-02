#
# Author:: Vassilis Rizopoulos (<var@zuehlke.com>)
# Cookbook Name:: windev
# Recipe:: drivers
#
# Copyright (c) 2014-2018 Zühlke, All Rights Reserved.

include_recipe 'windev::depot'

node.fetch('drivers',[]).each do |pkg|
  windev_install_driver pkg["name"] do
    if pkg["save_as"]
      source pkg["source"]
      cache "depot"=>node["software_depot"],"save_as"=>pkg["save_as"]
    else
      source "#{node['software_depot']}/#{pkg["source"]}"
    end
    version pkg["version"]
    certificate pkg["certificate"]
  end
end