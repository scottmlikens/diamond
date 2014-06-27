#
# Cookbook Name:: diamond
# Recipe:: example
#
# Copyright 2012, Scott M. Likens
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
diamond_install "custom" do
  action :tarball
  prefix '/opt/custom_diamond'
end

diamond_configure "custom" do
  action :config
  prefix '/opt/custom_diamond'
  runit_name 'custom_diamond'
  diamond_pidfile '/var/run/custom_diamond.pid'
  collectors_config_path '/opt/custom_diamond/etc/diamond/collectors'
  diamond_collectors_path '/opt/custom_diamond/share/diamond/collectors/'
  diamond_handlers [ "diamond.handler.graphite.GraphiteHandler" ]
end

diamond_plugin 'custom-NetworkCollector' do
  name 'NetworkCollector'
  collectors_path '/opt/custom_diamond/etc/diamond/collectors'
  runit_name 'custom_diamond'
  options({:enabled => true})
end

