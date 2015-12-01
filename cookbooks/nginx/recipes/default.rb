#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# 定数
USER_NAME = node[:local_accounts][:app][:name]
HOME_DIR = "/home/#{USER_NAME}"

package "epel-release"

package "nginx"

service "nginx" do
  action [:enable, :start]
  supports reload: true
end

template "/etc/nginx/nginx.conf" do
  source "nginx.conf.erb"
  notifies :reload, "service[nginx]"
  variables :USER_NAME => USER_NAME
end

file "/etc/nginx/conf.d/default.conf" do
  notifies :reload, "service[nginx]"
  content ""
end
