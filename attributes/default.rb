default['kibana']['install_path'] = '/var/www'

# Disable authentication by default. Set to true to install doorman proxy
default['kibana']['authentication'] = false

# Doorman OAuth proxy configuration
default['kibana']['auth_proxy']['install_dir'] = "#{node['kibana']['install_path']}/oauth"
default['kibana']['auth_proxy']['git']['url'] = 'https://github.com/movableink/doorman.git'
default['kibana']['auth_proxy']['git']['branch'] = 'master'
default['kibana']['auth_proxy']['git']['type'] = 'sync'
