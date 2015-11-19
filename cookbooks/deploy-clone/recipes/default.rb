#
# Cookbook Name:: deploy-clone
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# 定数
USER_NAME = node[:local_accounts][:app][:name]
HOME_DIR = "/home/#{USER_NAME}"

node[:deploys].each do |deploy_name, deploy|
  # git clone するとき、指定の鍵を使うための ssh ラッパー
  tmp_ssh_wrapper = "#{HOME_DIR}/tmp/ssh-wrapper-#{deploy_name}.sh" 

  directory "#{HOME_DIR}/tmp"

  file tmp_ssh_wrapper do
    owner USER_NAME
    mode "700"
    content "#!/bin/sh\nexec /usr/bin/ssh -o \"StrictHostKeyChecking=no\" -i #{HOME_DIR}/.ssh/#{deploy["identity_file"]} \"$@\""
  end

  # deploy のリポジトリをclone
  git deploy["path"] do
    user USER_NAME
    repository deploy["repository"]
    revision deploy["branch"]
    ssh_wrapper tmp_ssh_wrapper
  end
end
