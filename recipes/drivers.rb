#
# Author:: Vassilis Rizopoulos (<var@zuehlke.com>)
# Cookbook Name:: windev
# Recipe:: drivers
#
# Copyright (c) 2014 Zühlke, All Rights Reserved.


include_recipe 'windows::reboot_handler'
include_recipe 'windev::depot'

node['drivers'].each do |pkg|
  windev_install_driver pkg["name"] do
    source pkg["source"]
    version pkg["version"]
    cache "depot"=>node["software_depot"],"save_as"=>pkg["save_as"]
    certificate pkg["certificate"]
  end
end