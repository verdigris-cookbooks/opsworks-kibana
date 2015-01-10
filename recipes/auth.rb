include_recipe 'git'
include_recipe 'nodejs'

# Install Doorman OAuth proxy
git node['kibana']['auth_proxy']['install_dir'] do
  repository node['kibana']['auth_proxy']['git']['url']
  revision node['kibana']['auth_proxy']['git']['branch']
  action node['kibana']['auth_proxy']['git']['type'].to_sym
  user kibana_user
end

# Set up Doorman configuration
template "#{node['kibana']['auth_proxy']['install_dir']}/conf.js" do
  source 'doorman-conf.js.erb'
  cookbook 'opsworks_kibana'
  mode '0750'
  user kibana_user
  notifies :reload, 'service[nginx]'
  variables(
    auth_modules: node['kibana']['auth_proxy']['modules'].to_json
  )
end
