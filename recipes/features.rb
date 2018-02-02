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

ruby_block "GodMode" do
  block do
    FileUtils.mkdir_p "#{ENV['USERPROFILE']}\\Desktop\\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}"
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
