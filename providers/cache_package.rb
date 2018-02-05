#
# Author:: Vassilis Rizopoulos (<var@zuehlke.com>)
# Cookbook Name:: windev
# Provider:: cache_package
#
# Copyright:: 2015, Zühlke

require 'uri'

use_inline_resources # ~FC113

action :cache do
  if validate_source_attribute(new_resource)
    Chef::Log.info("Caching #{new_resource.source} in #{new_resource.depot} as #{new_resource.save_as}")
    save_as=::File.join(new_resource.depot,new_resource.save_as)
    directory new_resource.depot do
      action :create
      recursive true
    end
    remote_file save_as do
      source new_resource.source
      action :create_if_missing
    end
  end
end

def validate_source_attribute res
  begin
    URI::parse(res.source)
  rescue
    Chef::Log.fatal("Error parsing the package 'url': #{$!.message}")
  end
  return true
end