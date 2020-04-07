#
# Cookbook:: nodenginx
# Spec:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'nodenginx::default' do
  context 'When all attributes are default, on Ubuntu 18.04' do
    # for a complete list of available platforms and versions see:
    # https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
    platform 'ubuntu', '18.04'

    it 'runs apt update' do
      expect(chef_run).to update_apt_update 'update_sources'
    end

    it 'should install nginx' do
      expect(chef_run).to install_package('nginx')
    end

    it 'should install nodejs' do
      expect(chef_run).to install_package('nodejs')
    end

    it 'should enable and start nginx' do
      expect(chef_run).to enable_service 'nginx'
      expect(chef_run).to start_service 'nginx'
    end

    it 'should create proxy.conf template in sites-available' do
      expect(chef_run).to create_template("/etc/nginx/sites-available/proxy.conf").with_variables(proxy_port: 3000)
    end

    it 'should create symlink of proxy.conf from sites-available to sites-enabled' do
      expect(chef_run).to create_link('/etc/nginx/sites-enabled/proxy.conf').with_link_type(:symbolic)
    end

    it 'should delete default symlink in sites-enabled' do
      expect(chef_run).to delete_link('/etc/nginx/sites-enabled/default')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
