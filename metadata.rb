name             'opsworks_kibana'
maintainer       'Andrew Jo'
maintainer_email 'andrew@verdigris.co'
license          'Simplified BSD'
description      'Installs and configures Kibana'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

%w(git ark libarchive java runit).each do |cookbook|
  depends cookbook
end
