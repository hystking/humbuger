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

git "#{HOME_DIR}/tig" do
  user USER_NAME
  repository "https://github.com/jonas/tig"
end

bash "make tig" do
  user USER_NAME
  environment "HOME" => HOME_DIR
  flags "-e"
  not_if {File.exists? "#{HOME_DIR}/bin/tig"} # 冪等性の確保

  code <<-EOH
    cd #{HOME_DIR}/tig
    make
    make install
  EOH
end
