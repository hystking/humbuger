#
# Cookbook Name:: local-accounts
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# 定数
APP_NAME = node[:local_accounts][:app][:name]
APP_HOME = "/home/#{APP_NAME}"
DEVELOPERS = node[:local_accounts][:developers]

# appユーザを追加
user APP_NAME do
  shell '/bin/bash'
  home "/home/#{APP_NAME}"
  manage_home true
  action :create
end

# 開発者を追加
DEVELOPERS.each do |developer|
  developer_name = developer[:name]
  developer_home = "/home/#{developer_name}"

  # 開発者を追加
  user developer_name do
    shell '/bin/bash'
    home "/home/#{developer_name}"
    manage_home true
    action :create
  end

  # 開発者の.sshをつくる
  directory "#{developer_home}/.ssh" do
    mode 0700
    owner developer_name
  end
  
  # 開発者のauthorized_keysを追加
  file "#{developer_home}/.ssh/authorized_keys" do
    mode 0600
    owner developer_name
    content developer[:public_key]
  end
end


# current_user と app と開発者は wheel
group "wheel" do
  members [APP_NAME, node["current_user"]] + DEVELOPERS.map(&:name)
end

# パスワード無しでsudoできるあれを追加
file '/etc/sudoers.d/nopasswd' do
  content "%wheel ALL=NOPASSWD: ALL"
end
