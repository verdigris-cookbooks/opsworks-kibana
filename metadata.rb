name             'opsworks_kibana'
maintainer       'Andrew Jo'
maintainer_email 'andrew@verdigris.co'
license          'Simplified BSD'
description      'Installs and configures Kibana'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'kibana', '>=1.3.0'
depends 'git', '~3.1.0'
depends 'nodejs', '~2.2.0'
