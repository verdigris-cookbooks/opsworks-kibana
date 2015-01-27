require 'spec_helper'

describe 'kibana::install' do
  let(:runner) { ChefSpec::SoloRunner.new }
  let(:node) { runner.node }

  let(:chef_run) do
    node.set['kibana']['user'] = 'testuser'
    node.set['kibana']['install_dir'] = '/var/www/kibana'
    node.set['kibana']['install_type'] = 'file'
    node.set['kibana']['config_cookbook'] = 'kibana'
    runner.converge described_recipe
  end

  it 'creates kibana user' do
    expect(chef_run).to create_kibana_user('testuser').with(
      user: 'testuser',
      group: 'testuser',
      home: '/var/www/kibana'
    )
  end

  it 'installs kibana' do
    expect(chef_run).to create_kibana_install('kibana').with(
      user: 'testuser',
      group: 'testuser',
      install_dir: '/var/www/kibana',
      install_type: 'file'
    )
  end

  it 'creates kibana configuration from template' do
    expect(chef_run).to(
      create_template('/var/www/kibana/current/config/kibana.yml').with(
        source: 'kibana.yml.erb',
        cookbook: 'kibana',
        mode: '0644',
        user: 'testuser'
      )
    )
  end

  it 'creates a kibana runit service' do
    expect(chef_run).to enable_runit_service('kibana')
  end
end
