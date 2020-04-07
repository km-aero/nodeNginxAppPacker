#
# Cookbook:: nodenginx
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

apt_update 'update_sources' do
  action :update
end

package 'nginx'

service 'nginx' do
  action [:enable, :start]
end

# create template
template '/etc/nginx/sites-available/proxy.conf' do
  source 'proxy.conf.erb'
  variables proxy_port: node['nginx']['proxy_port']
end

# link sites-available to sites-enabled
link '/etc/nginx/sites-enabled/proxy.conf' do
  to '/etc/nginx/sites-available/proxy.conf'
end

# delete default link
link '/etc/nginx/sites-enabled/default' do
  action :delete
  notifies :restart, 'service[nginx]'
end

include_recipe 'nodejs'

# package 'npm'
npm_package 'pm2'
npm_package 'react'
