#
# Cookbook Name:: app-god
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# 定数
USER_NAME = node[:local_accounts][:app][:name]
HOME_DIR = "/home/#{USER_NAME}"
APPS_GOD = node[:apps].select{|app_name, app| app.has_key? "god"}

directory "/etc/god"

APPS_GOD.each do |app_name, app|
  template "/etc/god/#{app_name}.conf" do
    source "app.conf.erb"
    variables app: app, app_name: app_name
  end
end

template "/etc/init.d/god" do
  mode 655
  variables HOME_DIR: HOME_DIR, APPS_GOD: APPS_GOD
  source "init.erb"
end

service "god" do
  action [:enable, :start]
end
