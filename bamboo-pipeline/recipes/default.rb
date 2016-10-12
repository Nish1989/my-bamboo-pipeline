#
# Cookbook Name:: bamboo-agent
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
include_recipe 'java'
include_recipe 'ant::install_source'
ant_library "JMeter" do
  url "http://www.programmerplanet.org/media/ant-jmeter/ant-jmeter-1.1.1.jar"
end

include_recipe "jmeter"

include_recipe "nodejs"
# install newman
nodejs_npm "newman"
include_recipe "poise-python"

# download the CF CLI
remote_file "#{Chef::Config[:file_cache_path]}/cf-cli-installer.rpm" do
    source "https://cli.run.pivotal.io/stable?release=redhat64&source=github"
    action :create
end

# install the CF CLI
rpm_package "cf-cli" do
    source "#{Chef::Config[:file_cache_path]}/cf-cli-installer.rpm"
    action :install
end

execute "pip install" do
  command 'sudo yum install -y python-pip'
end

execute 'libxslt install' do
  command 'yum install -y libxslt-devel'
end

execute 'python-devel install' do
  command 'yum install -y python-devel'
end

# install Blazemeter
execute "bzt install" do
  command 'sudo pip install --upgrade bzt'
end

execute "install python tools" do
  command 'sudo pip install --upgrade setuptools'
end


execute "mkdir for bamboo" do
  command 'sudo mkdir -p /usr/local/bamboo/'
end

cookbook_file '/usr/local/bamboo/bamboo-agent-installer.jar' do
  source 'bamboo-agent-installer.jar'
  mode '777'
  action :create
end

cookbook_file '/usr/local/bamboo/pipelineCredentials.sh' do
  source 'pipelineCredentials.sh'
  mode '777'
  action :create
end

include_recipe 'bamboo-agent'
