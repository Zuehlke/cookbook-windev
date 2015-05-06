#
# Author:: Vassilis Rizopoulos (<var@zuehlke.com>)
# Cookbook Name:: windev
# Resource:: cache_package
#
# Copyright:: 2015, Zühlke

actions :cache
default_action :cache 
attribute :save_as, :name_attribute => true,:kind_of => String, :required=>true
attribute :depot, :kind_of => String, :required=>true
attribute :source, :kind_of => String, :required=>true
