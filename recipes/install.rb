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

include_recipe 'kibana'

# Kibana should run as the same user nginx runs as if not specified
if node['kibana']['user'].empty?
  if !node['kibana']['webserver'].empty?
    webserver = node['kibana']['webserver']
    kibana_user = node[webserver]['user']
  else
    kibana_user = 'nobody'
  end
else
  kibana_user = node['kibana']['user']
  kibana_user kibana_user do
    name kibana_user
    group kibana_user
    home node['kibana']['install_dir']
    action :create
  end
end

# Install Kibana
kibana_install 'kibana' do
  user kibana_user
  group kibana_user
  install_dir node['kibana']['install_dir']
  install_type node['kibana']['install_type']
  action :create
end

# Host Kibana behind nginx proxy
# See: https://github.com/lusis/chef-kibana/blob/569d020d2ddfad4fc6234d25d13eb8ad115172ab/recipes/nginx.rb
include_recipe 'kibana::nginx'

# Install Doorman OAuth proxy
if node['kibana']['authentication'] && !node['kibana']['auth_proxy'].empty?
  include_recipe 'git'
  include_recipe 'nodejs'

  git node['kibana']['auth_proxy']['install_dir'] do
    repository node['kibana']['auth_proxy']['git']['url']
    revision node['kibana']['auth_proxy']['git']['branch']
    action node['kibana']['auth_proxy']['git']['type'].to_sym
    user kibana_user
  end
end
