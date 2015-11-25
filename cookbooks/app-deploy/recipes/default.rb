#
# Cookbook Name:: app-deploy
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# 定数
USER_NAME = node[:local_accounts][:app][:name]
HOME_DIR = "/home/#{USER_NAME}"
APPS_DEPLOY = node[:apps].select{|app_name, app| app.has_key? "deploy"}

directory "/var/www" do
  owner USER_NAME
  mode "755"
end

APPS_DEPLOY.each do |app_name, app|
  # deploy する
  
  directory "#{HOME_DIR}/tmp"

  touch_file = "#{HOME_DIR}/tmp/deploy_#{app_name}_touch"

  bash "deploy #{app_name}" do
    user USER_NAME
    environment "HOME" => HOME_DIR
    flags "-e"
    not_if {File.exists? touch_file} # 冪等性の確保

    code <<-EOH
      source #{HOME_DIR}/.bash_profile
      cd #{app["deploy"]["path"]}
      bundle install --path vendor/bundle
      bundle exec cap #{app["deploy"]["environment"]} deploy
    EOH
  end

  file touch_file
end
