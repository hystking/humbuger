#
# Cookbook Name:: dev
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# 定数
USER_NAME = node[:local_accounts][:app][:name]
HOME_DIR = "/home/#{USER_NAME}"

package "vim-common"
package "vim-minimal"
package "vim-enhanced"
package "vim-X11"
package "pcre-devel"
package "xz-devel"

bash "groupinstall Development Tools" do
  not_if {"which aclocal"} # 冪等性の確保
  user USER_NAME
  environment "HOME" => HOME_DIR
  flags "-e"
  code <<-EOH
  sudo yum groupinstall "Development Tools" -y
  EOH
end

git "#{HOME_DIR}/tig" do
  user USER_NAME
  repository "https://github.com/jonas/tig"
end

bash "make tig" do
  user USER_NAME
  environment "HOME" => HOME_DIR
  flags "-e"
  not_if {"which tig"} # 冪等性の確保

  code <<-EOH
    cd #{HOME_DIR}/tig
    make
    make install
  EOH
end

git "#{HOME_DIR}/ag" do
  user USER_NAME
  repository "https://github.com/ggreer/the_silver_searcher.git"
end

bash "make ag" do
  user USER_NAME
  environment "HOME" => HOME_DIR
  flags "-e"
  not_if {"which ag"} # 冪等性の確保

  code <<-EOH
    cd #{HOME_DIR}/ag
    ./build.sh
    sudo make install
  EOH
end
