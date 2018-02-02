#
# Cookbook Name:: windev
# Recipe:: auto_chef
#
# Author:: Vassilis Rizopoulos (<var@zuehlke.com>)
#
# Copyright (c) 2014-2018 Zühlke, All Rights Reserved.

#Create a user to restart the process after booting
user "chef-auto-start" do
  comment "Chef installation user"
  password 'chef-auto-start'
  force true
  action :remove
end
#Set up autologin for chef-auto-start
registry_key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\WinLogon" do 
  values [{:name => "AutoAdminLogin",:type => :string,:data => "0"}, 
    {:name => "AutoAdminLogon",:type => :string,:data => "0"}, 
    {:name => "DefaultUserName",:type => :string,:data => ""},
    {:name => "DefaultPassword",:type => :string,:data => ""}
  ]
  action :create
end
#
windows_auto_run 'Chef Run' do
  program "echo"
  args    ""
  action  :remove
end
#
reboot "AutoChefReboot" do
  action :request_reboot
  reason 'Need to reboot to remove the last traces of auto_chef.'
  delay_mins 1
end
