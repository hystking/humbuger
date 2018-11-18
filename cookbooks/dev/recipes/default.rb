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
package "tmux"

bash "groupinstall Development Tools" do
  user USER_NAME
  environment "HOME" => HOME_DIR
  flags "-e"
  not_if "which aclocal", :user => USER_NAME # 冪等性の確保
  code <<-EOH
  sudo yum groupinstall "Development Tools" -y
  EOH
end

git "#{HOME_DIR}/tig" do
  user USER_NAME
  repository "git@github.com:jonas/tig.git"
end

bash "make tig" do
  user USER_NAME
  environment "HOME" => HOME_DIR
  flags "-e"
  not_if "ls #{HOME_DIR}/bin/tig", :user => USER_NAME # 冪等性の確保

  code <<-EOH
    cd #{HOME_DIR}/tig
    make configure
    ./configure --prefix=#{HOME_DIR}
    make
    make install
  EOH
end

git "#{HOME_DIR}/ag" do
  user USER_NAME
  repository "git@github.com:ggreer/the_silver_searcher.git"
end

bash "make ag" do
  user USER_NAME
  environment "HOME" => HOME_DIR
  flags "-e"
  not_if "ls #{HOME_DIR}/bin/ag", :user => USER_NAME # 冪等性の確保

  code <<-EOH
    cd #{HOME_DIR}/ag
    ./build.sh --prefix=#{HOME_DIR}
    make
    make install
  EOH
end
