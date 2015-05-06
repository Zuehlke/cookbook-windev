#
# Author:: Vassilis Rizopoulos (<var@zuehlke.com>)
# Cookbook Name:: windev
# Recipe:: depot
#
# Copyright (c) 2014 Zühlke, All Rights Reserved.

directory node["software_depot"]

node["cache"].each do |e|
  windev_cache_package e['save_as'] do
    source e["source"]
    depot node["software_depot"]
  end
end