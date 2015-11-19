#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "epel-release"

package "nginx"

service "nginx" do
  notifies :enable, "service[nginx]"
  notifies :start, "service[nginx]"
end

template "/etc/nginx/nginx.conf" do
  source "nginx.conf.erb"
  notifies :reload, "service[nginx]"
end