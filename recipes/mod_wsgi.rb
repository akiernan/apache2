#
# Cookbook Name:: apache2
# Recipe:: mod_wsgi
#
# Copyright 2008-2012, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

filename = nil

case node['platform_family']
when "debian"

  package "libapache2-mod-wsgi"

when "rhel", "fedora", "arch"
  p = 'mod_wsgi'
  if platform_family?("rhel")
    major_version = node['platform_version'].split('.').first.to_i
    if major_version < 6
      p = 'python26-mod_wsgi'
      filename = 'python26-mod_wsgi.so'
    end
  end

  package p do
    notifies :run, "execute[generate-module-list]", :immediately
  end

end

['wsgi.conf', 'python26-mod_wsgi.conf'].each do |f|
  file "#{node['apache']['dir']}/conf.d/#{f}" do
    action :delete
    backup false
  end
end

apache_module "wsgi" do
  filename filename
end
