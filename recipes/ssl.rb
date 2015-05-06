#
# Cookbook Name:: windev
# Recipe:: ssl
#
# Copyright (c) 2014 Zühlke, All Rights Reserved.

directory "C:\\tools\\SSLcerts\\"

remote_file "C:/tools/SSLCerts/cacert.pem" do
  source node['certificate_bundle']
  action :create_if_missing
end

remote_file "C:/tools/SSLCerts/ca-bundle.crt" do
  source "https://raw.githubusercontent.com/bagder/ca-bundle/master/ca-bundle.crt"
  action :create_if_missing
end

env "SSL_CERT_FILE" do
  name "SSL_CERT_FILE"
  value "c:\\tools\\SSLCerts\\cacert.pem"
  action :create
end
