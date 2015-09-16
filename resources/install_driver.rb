#
# Author:: Vassilis Rizopoulos (<var@zuehlke.com>)
# Cookbook Name:: windev
# Resource:: install_driver
#
# Copyright:: 2015, Zühlke


#drivers":[
#    {"name":"STLink USB","package":"http://bin.repo.local/stlink_usb_drivers.zip","cache_as":"stlink_usb_drivers.zip","certificate":"st.cer","version":"1.01"}
#  ],

actions :install
default_action :install 
attribute :name, :name_attribute => true,:kind_of => String, :required=>true
attribute :source, :kind_of => String, :required=>true
attribute :version, :kind_of => String, :required=>true
attribute :certificate, :kind_of => String
attribute :cache, :kind_of => Hash
