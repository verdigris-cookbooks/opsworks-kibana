#
# Cookbook Name:: kibana
# Recipe:: default
#
# Copyright (c) 2014, Verdigris Technologies Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

kibana_user = node['kibana']['user']
kibana_config = "#{node['kibana']['install_dir']}/current/"\
                "#{node['kibana']['config_path']}"
es_server = "#{node['kibana']['es_scheme']}#{node['kibana']['es_server']}:"\
            "#{node['kibana']['es_port']}"

user kibana_user do
  home "/home/#{kibana_user}"
  system true
  action :create
  manage_home true
end

group kibana_user do
  members kibana_user
  append true
  system true
end

directory node['kibana']['install_dir'] do
  recursive true
  owner kibana_user
  group kibana_user
  mode '0755'
end

case node['kibana']['install_type']
when 'git'
  include_recipe 'git::default'

  git "#{node['kibana']['install_dir']}/#{node['kibana']['git']['revision']}" do
    repository node['kibana']['git']['url']
    revision node['kibana']['git']['branch']
    action node['kibana']['git']['action'].to_sym
    user kibana_user
  end

  link "#{node['kibana']['install_dir']}/current" do
    to "#{node['kibana']['install_dir']}/#{node['kibana']['git']['revision']}"\
       "/src"
  end
when 'file'
  include_recipe 'libarchive::default'

  cache_path = Chef::Config[:file_cache_path]
  kibana_version = node['kibana']['version']

  remote_file "#{cache_path}/kibana_#{kibana_version}.tar.gz" do
    checksum lazy { node['kibana']['file']['checksum'] }
    source node['kibana']['file']['url']
    action [:create_if_missing]
  end

  libarchive_file "kibana_#{node['kibana']['version']}.tar.gz" do
    path "#{cache_path}/kibana_#{kibana_version}.tar.gz"
    extract_to node['kibana']['install_dir']
    owner kibana_user
    action [:extract]
  end

  link "#{node['kibana']['install_dir']}/current" do
    to "#{node['kibana']['install_dir']}/kibana-#{kibana_version}"
  end

  node.set['kibana']['web_dir'] = "#{node['kibana']['install_dir']}/current"
  node.save unless Chef::Config[:solo]

  include_recipe 'java::default' if node['kibana']['install_java']
  include_recipe 'runit::default'

  runit_service 'kibana' do
    options(
      user: kibana_user,
      home: "#{node['kibana']['install_dir']}/current"
    )
    cookbook 'opsworks_kibana'
    subscribes :restart, "template[#{kibana_config}]", :delayed
  end
end

template kibana_config do
  source node['kibana']['file']['config_template']
  cookbook node['kibana']['file']['config_template_cookbook']
  mode '0644'
  user kibana_user
  group kibana_user
  variables(
    port: node['kibana']['java_webserver_port'],
    listen_address: node['kibana']['java_webserver_listen'],
    index: node['kibana']['config']['kibana_index'],
    elasticsearch: es_server,
    default_app_id: node['kibana']['config']['default_app_id'],
    request_timeout: node['kibana']['config']['request_timeout'],
    shard_timeout: node['kibana']['config']['shard_timeout']
  )
end
