default['kibana']['file']['config_template_cookbook'] = "kibana"

# Kibana Java Web Server
default['kibana']['java_webserver_listen'] = "0.0.0.0"

# Parent directory of install_dir. This is required because of the `file` method.
default['kibana']['install_path'] = '/var/www'

# Doorman OAuth proxy configuration
default['kibana']['auth_proxy']['install_dir'] = "#{node['kibana']['install_path']}/oauth"

# Git repository for doorman
default['kibana']['auth_proxy']['git']['url'] = 'https://github.com/movableink/doorman.git'
default['kibana']['auth_proxy']['git']['branch'] = 'master'
default['kibana']['auth_proxy']['git']['type'] = 'sync'

# Port to listen on for doorman
default['kibana']['auth_proxy']['port'] = 8085

# Session options
default['kibana']['auth_proxy']['session']['name'] = "__kibana"             # cookie name
default['kibana']['auth_proxy']['session']['maxage'] = 24 * 60 * 60 * 1000  # milliseconds
default['kibana']['auth_proxy']['session']['secret'] = 'AeV8Thaieel0Oor6shainu6OUfoh3ohwZaemohC0Ahn3guowieth2eiCkohhohG4' # change this for security reasons

default['kibana']['auth_proxy']['modules'] = {}

default['kibana']['config']['default_app_id'] = "discovery"
default['kibana']['config']['request_timeout'] = "60"
default['kibana']['config']['shard_timeout'] = "30000"
default['kibana']['config']['verify_ssl'] = false
