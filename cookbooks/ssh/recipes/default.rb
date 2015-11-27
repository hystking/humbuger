#
# Cookbook Name:: ssh
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# 定数
USER_NAME = node[:local_accounts][:app][:name]
HOME_DIR = "/home/#{USER_NAME}"

# ssh ディレクトリを作る
directory "#{HOME_DIR}/.ssh" do
  mode 0700
  owner USER_NAME
end

# appのlocalhostのキーペアをつくる
bash "create localhost key pair" do
  key_name = "localhost.id_rsa"
  user USER_NAME
  flags "-e"
  not_if {File.exists? "#{HOME_DIR}/.ssh/#{key_name}"} # 冪等性の確保

  code <<-EOH
    ssh-keygen -f #{HOME_DIR}/.ssh/#{key_name} -N ""
    cat #{HOME_DIR}/.ssh/#{key_name}.pub > #{HOME_DIR}/.ssh/authorized_keys
    chmod 0600 #{HOME_DIR}/.ssh/#{key_name}
  EOH
end


# keyをコピー
node[:ssh][:keys].each do |key|
  template "#{HOME_DIR}/.ssh/#{key}" do
    owner USER_NAME
    mode "600"
    source key
  end
end

# ssh config を更新
template "#{HOME_DIR}/.ssh/config" do
  owner USER_NAME
  mode "600"
  source "config.erb"
  variables configs: node[:ssh][:configs]
end
