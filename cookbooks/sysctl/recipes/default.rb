#
# Cookbook Name:: sysctl
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

ruby_block "Edit /etc/sysctl.conf" do
  not_if "cat /etc/sysctl.conf | grep 'net.core.somaxconn'"
  block do
    rc = Chef::Util::FileEdit.new("/etc/sysctl.conf")
    rc.insert_line_if_no_match /^net.core.somaxconn.*$/, "net.core.somaxconn = 65536"
    rc.write_file
  end

  notifies :run, "execute[Reload /etc/sysctl.conf]"
end

execute "Reload /etc/sysctl.conf" do
  command "sysctl -e -p"
  action :nothing
end
