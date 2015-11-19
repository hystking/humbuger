#
# Cookbook Name:: rbenv
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# 定数
USER_NAME = node[:local_accounts][:app][:name]
HOME_DIR = "/home/#{USER_NAME}"

# Rubyのインストールに必要なパッケージ
package "gcc"
package "openssl-devel"
package "readline-devel"
package "zlib-devel"

# rbenvのインストール
bash "install-rbenv" do
  user USER_NAME
  flags "-e" # エラーが出たらexitする
  not_if {File.exists? "#{HOME_DIR}/.rbenv"} # 冪等性の確保
  environment "HOME" => HOME_DIR

  code <<-EOH
    git clone https://github.com/sstephenson/rbenv.git #{HOME_DIR}/.rbenv
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> #{HOME_DIR}/.bash_profile
    echo 'eval "$(rbenv init -)"' >> #{HOME_DIR}/.bash_profile
    source #{HOME_DIR}/.bash_profile
    git clone https://github.com/sstephenson/ruby-build.git #{HOME_DIR}/.rbenv/plugins/ruby-build
  EOH
end


# それぞれのバージョンのインストール
node[:rbenv][:ruby_versions].each do |ruby_version|
  bash "install-ruby-version-#{ruby_version}" do
    user USER_NAME
    flags "-e" # エラーが出たらexitする
    not_if {File.exists? "#{HOME_DIR}/.rbenv/versions/#{ruby_version}"} # 冪等性の確保
    environment "HOME" => HOME_DIR

    code <<-EOH
      source #{HOME_DIR}/.bash_profile
      rbenv install #{ruby_version}
    EOH
  end
end

# globalのrubyの設定

directory "#{HOME_DIR}/tmp"

touch_file = "#{HOME_DIR}/tmp/rbenv_global_touch"

bash "set rbenv global" do
  user USER_NAME
  flags "-e" # エラーが出たらexitする
  environment "HOME" => HOME_DIR
  not_if {File.exists? "#{touch_file}"} # 冪等性の確保

  code <<-EOH
    source #{HOME_DIR}/.bash_profile
    rbenv global #{node[:rbenv][:global]}
    rbenv rehash
    gem install bundler
    gem install god
    bundle config build.nokogiri --use-system-libraries
  EOH
end

file touch_file
