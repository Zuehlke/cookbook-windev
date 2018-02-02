#
# Cookbook Name:: windev
# Recipe:: packages
#
# Copyright (c) 2014-2018 Zühlke, All Rights Reserved.

include_recipe 'windev::installer_packages'
include_recipe 'windev::zip_packages'
include_recipe 'windev::choco_packages'
