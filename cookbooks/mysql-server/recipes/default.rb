#
# Cookbook Name:: mysql-server
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "mysql-server"

service "mysqld" do
  action [:enable, :start]
end

