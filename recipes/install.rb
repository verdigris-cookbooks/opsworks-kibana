#
# Cookbook Name:: kibana
# Recipe:: config
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

install_type = node['kibana']['install_type']

kibana_user = node['kibana']['user']
kibana_user kibana_user do
  name kibana_user
  group kibana_user
  home node['kibana']['install_dir']
  action :create
end

kibana_install 'kibana' do
  user kibana_user
  group kibana_user
  install_dir node['kibana']['install_dir']
  install_type install_type
  action :create
end

kibana_config = "#{node['kibana']['install_dir']}/current/"\
                "#{node['kibana'][install_type]['config']}"

es_server = "#{node['kibana']['es_scheme']}#{node['kibana']['es_server']}:"\
            "#{node['kibana']['es_port']}"

template kibana_config do
  source node['kibana'][install_type]['config_template']
  cookbook node['kibana'][install_type]['config_template_cookbook']
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

if install_type == 'file'

  include_recipe 'java::default' if node['kibana']['install_java']
  include_recipe 'runit::default'

  runit_service 'kibana' do
    options(
      user: kibana_user,
      home: "#{node['kibana']['install_dir']}/current"
    )
    cookbook 'kibana_lwrp'
    subscribes :restart, "template[#{kibana_config}]", :delayed
  end

end
