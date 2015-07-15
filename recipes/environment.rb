#
# Cookbook Name:: windev
# Recipe:: environment
#
# Copyright (c) 2015 Zühlke, All Rights Reserved.

node.fetch('environment',{}).each do |k,v|
  env k do
    name k
    value v
    action :create
  end
end