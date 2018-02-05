#
# Author:: Vassilis Rizopoulos (<var@zuehlke.com>)
# Cookbook Name:: windev
# Provider:: install_driver
#
# Copyright:: 2015, Zühlke

require 'uri'

def dpinst tmpfile
  Chef::Application.fatal!("Device driver package not found in #{tmpfile}") unless ::File.exist?(tmpfile)
  ["dpinst_amd64.exe","dpinst-amd64.exe","dpinst_x64.exe","dpinst-x64.exe"].each do |dp|
    util= ::File.expand_path("#{tmpfile}/#{dp}")
    if ::File.exists?(util)
      ::FileUtils.cp(util,::File.join("#{tmpfile}/dpinst.exe"),:verbose=>false)
      return util
    end
  end
  Chef::Application.fatal!("Windows device driver package did not include a recognized instance of DPINST")
end

use_inline_resources # ~FC113

action :install do
  tmpfile=::File.expand_path(::File.join(ENV['TEMP'],new_resource.name.gsub(" ","_")))
  versionfile="#{tmpfile}/#{new_resource.version}.version"

  if !::File.exists?(versionfile)
    if new_resource.cache 
      windev_cache_package new_resource.cache['save_as'] do
        source new_resource.source
        depot new_resource.cache['depot']
      end
      installer=::File.expand_path(::File.join(new_resource.cache['depot'],new_resource.cache['save_as']))
    else
      installer=::File.expand_path(::File.join(new_resource.source))
    end

    directory tmpfile do
      action :delete
      recursive true
    end

    windows_zipfile tmpfile do
      source installer
      action :unzip
    end

    if new_resource.certificate
      tmp_cert= ::File.join(tmpfile,new_resource.certificate)
      cookbook_file new_resource.certificate do
        path tmp_cert
        action :create_if_missing
      end
      batch "install certificate" do
        code <<-EOT
          certutil -addstore TrustedPublisher "#{tmp_cert}"
        EOT
        returns 0
      end
    end

    ruby_block "find dpinst" do
      block do
        dpinst(tmpfile)
      end
      action :run
    end

    dpinst_xml=::File.join(tmpfile,"dpinst.xml")
    ruby_block "Silent dpinst config" do
      block do
        xml=<<-EOT
        <?xml version="1.0"?> 
        <dpInst> 
           <suppressWizard/> 
           <quietInstallStrict/> 
        </dpInst> 
        EOT
        ::File.open(dpinst_xml,"wb"){|f| f.write(xml)}
      end
      not_if {::File.exist?(dpinst_xml)}
      action :run
    end

    batch "driver install #{new_resource.name}" do
      code <<-EOT
        cd /D "#{tmpfile}"
        dpinst.exe /Q /C /se
      EOT
      returns [0,1,2,3,4,128,129,130,131,132,256,257,258,259,260,512,513,514,514,515,768,769,770,771,772,1024,1025,1026,1027,1028]
    end

    file versionfile do
      action :create
    end
  end
end