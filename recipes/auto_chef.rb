#
# Cookbook Name:: windev
# Recipe:: auto_chef
#
# Author:: Vassilis Rizopoulos (<var@zuehlke.com>)
#
# Copyright (c) 2014-2018 Zühlke, All Rights Reserved.

#Create a user to restart the process after booting

cmd=ENV["CHEF_SCRIPT"]
raise "windev::auto_chef: CHEF_SCRIPT not defined, cannot register Chef for startup" unless cmd
cmd_params=ENV["CHEF_CONFIG"]
cmd_params||=node.fetch("chef",{})["config"]
raise "windev::auto_chef: No Chef configuration attribute defined. Add node[\"chef\"][\"config\"] to your configuration or define CHEF_CONFIG" unless cmd_params

user "chef-auto-start" do
  comment "Chef installation user"
  password 'chef-auto-start'
  action :create
end
#add the user to the administrators group
group "Administrators" do
  action :modify
  members "chef-auto-start"
  append true
end
#Set up autologin for chef-auto-start
registry_key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\WinLogon" do 
  values [{:name => "AutoAdminLogin",:type => :string,:data => "1"}, 
    {:name => "AutoAdminLogon",:type => :string,:data => "1"}, 
    {:name => "DefaultUserName",:type => :string,:data => "chef-auto-start"},
    {:name => "DefaultPassword",:type => :string,:data => "chef-auto-start"}
  ]
  action :create
end
#Register the chef command to run on startup
windows_auto_run 'Chef Run' do
  program cmd
  args    cmd_params
  action  :create
end
