#
# Cookbook Name:: vm
# Recipe:: features
#
# Copyright (c) 2014-2018 Zühlke, All Rights Reserved.

node['windows_features']['remove'].each do |feat|
  windows_feature(feat)do 
    action :remove
  end
end

batch "firewall off" do
  code <<-EOT
  NetSh Advfirewall set allprofiles state off
  EOT
end

registry_key "HKLM\\SOFTWARE\\MICROSOFT\\WINDOWS\\CURRENTVERSION\\POLICIES\\EXPLORER" do 
  values [{:name => "HIDESCAHEALTH",:type => :dword,:data => "1"}]
  action :create
end
