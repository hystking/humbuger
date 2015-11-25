#
# Cookbook Name:: n
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# 定数
USER_NAME = node[:local_accounts][:app][:name]
HOME_DIR = "/home/#{USER_NAME}"

# rbenvのインストール
bash "install n" do
  user USER_NAME
  flags "-e" # エラーが出たらexitする
  not_if {File.exists? "#{HOME_DIR}/n"} # 冪等性の確保
  environment "HOME" => HOME_DIR

  code <<-EOH
    curl -L http://git.io/n-install | bash -s -- -y
  EOH
end
