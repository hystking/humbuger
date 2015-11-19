#
# Cookbook Name:: vagrant-environment
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# stop iptables for Mac
service "iptables" do
  action [:disable, :stop]
end
