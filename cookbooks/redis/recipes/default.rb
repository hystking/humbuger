#
# Cookbook Name:: redis
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "redis" do
  options "--enablerepo=epel"
end

service "redis" do
  action [:enable, :start]
end
