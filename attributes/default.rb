default['kibana']['install_path'] = '/var/www'

# Disable authentication by default. Set to true to install doorman proxy
default['kibana']['authentication'] = false

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
