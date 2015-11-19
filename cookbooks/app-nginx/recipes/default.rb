#
# Cookbook Name:: app-nginx
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

APPS_NGINX = node[:apps].select{|app_name, app| app.has_key? "nginx"}

APPS_NGINX.each do |app_name, app|
  if app["nginx"]["basic"]
    file "/etc/nginx/#{app_name}.htpasswd" do
      mode 0644
      content "#{app["nginx"]["basic"]["user"]}:#{app["nginx"]["basic"]["password"].crypt(rand(10..100).to_s)}"
    end
  end

  template "/etc/nginx/conf.d/#{app_name}.conf" do
    variables :app => app, :app_name => app_name
    source "app.conf.erb"
    notifies :reload, "service[nginx]"
  end
end

