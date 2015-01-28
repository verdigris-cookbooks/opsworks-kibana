default['kibana']['install_type'] = 'file'
default['kibana']['version'] = '4.0.0-beta3'

# Values to use for git method of installation
default['kibana']['git']['url'] = 'https://github.com/elasticsearch/kibana.git'
default['kibana']['git']['branch'] = '8faae21'
default['kibana']['git']['action'] = 'sync'
default['kibana']['git']['config_path'] = 'src/server/config/kibana.yml'
default['kibana']['git']['config_template'] = 'kibana.yml.erb'
default['kibana']['git']['config_template_cookbook'] = "opsworks_kibana"

# Values to use for file method of installation
default['kibana']['file']['url'] = 'https://download.elasticsearch.org/kibana/'\
                                   'kibana/kibana-4.0.0-beta3.tar.gz'
default['kibana']['file']['checksum'] = nil # sha256 ( shasum -a 256 FILENAME )
default['kibana']['file']['config'] = 'config/kibana.yml' # relative path of config file
default['kibana']['file']['config_template'] = 'kibana.yml.erb' # template to use for config
default['kibana']['file']['config_template_cookbook'] = 'kibana' # cookbook containing config template

# Kibana Java Web Server
default['kibana']['java_webserver_listen'] = "0.0.0.0"
default['kibana']['java_webserver_port'] = 5601

# Parent directory of install_dir. This is required because of the `file` method.
default['kibana']['install_path'] = '/var/www'

# Actual installation directory of Kibana.
default['kibana']['install_dir'] = "#{node['kibana']['install_path']}/kibana"

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

# Used to configure proxy information for the webserver to proxy ES calls
default['kibana']['es_server'] = '127.0.0.1'
default['kibana']['es_port'] = '9200'
default['kibana']['es_role'] = 'elasticsearch'
default['kibana']['es_scheme'] = 'http://'

# Default kibana user
default['kibana']['user'] = 'kibana'
