Description
===========

This cookbook provides providers and resources to configure and manage [Diamond](https://github.com/BrightcoveOS/Diamond) Diamond is a python daemon that collects system metrics and publishes them to Graphite. It is capable of collecting cpu, memory, network, i/o, load and disk metrics. Additionally, it features an API for implementing custom collectors for gathering metrics from almost any source.

Requirements
------------


## Chef Version
Requires Chef 11 or higher.

## Cookbooks

Opscode Cookbooks:

* build-essential
* python
* git

Default Collectors
=======================

Diamond has the following [Collectors](https://github.com/BrightcoveOS/Diamond/wiki/Collectors) enabled by default:  
`Cpu`, `DiskSpace`, `DiskUsage`, `LoadAvg`, `Memory`, `SockStat`, `Vmstat`.

Resources and Providers
=======================

This cookbook provides three resources and corresponding providers.

`install.rb`
-------------
Install Diamond with this resource.

Actions:

* `git` - Clones the source from [Github](https://github.com/BrightcoveOS/Diamond.git) and installs using `python setup.py install`
* `tarball` - Fetches a tarball containing using HTTP and installs using `python setup.py install`

Attribute Parameters:

## diamond::install

<table>
  <tr>
    <th>Attribute</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td>prefix</td>
    <td>String</td>
    <td>Prefix of where to install diamond to</td>
    <td><tt><code>/opt/diamond</code></tt></td>
  </tr>
  <tr>
    <td>git_repository_uri</td>
    <td>String</td>
    <td>Location of where the cookbook fetches Diamond from to install</td>
    <td><tt><code>https://github.com/BrightcoveOS/Diamond.git</code></tt></td>
  </tr>
  <tr>
    <td>git_reference</td>
    <td>String</td>
    <td>Which git reference to install Diamond from</td>
    <td><tt><code>master</code></tt></td>
  </tr>
  <tr>
    <td>required_python_packages</td>
    <td>Hash</td>
    <td>List of python packages to install for Diamond</td>
    <td><tt><code>{ "configobj" => "4.7.2","psutil" => "0.6.1"}></code></tt></td>
  </tr>
  <tr>
    <td>cookbook</td>
    <td>String</td>
    <td>Name of the cookbook that holds the erb templates</td>
    <td><tt><code>diamond</code></tt></td>
  </tr>
  <tr>
    <td>tarball_path</td>
    <td>String</td>
    <td>Url of the Tarball to install Diamond with</td>    
    <td><tt><code>https://github.com/BrightcoveOS/Diamond/archive/master.tar.gz</code></tt></td>
  </tr>
  <tr>
    <td>tarball_extract_fldr</td>
    <td>String</td>
    <td>Name of the directory that holds Diamond in the tarball</td>
    <td><tt><code>Diamond-master</code></tt></td>
  </tr>
</table>

`configure.rb`
-------------
Configure Diamond with this resource.

Actions:

* `config` - Creates `#{new_resource.prefix}/etc/diamond/diamond.conf`

Attribute Parameters:

### diamond::configure

<table>
  <tr>
    <th>Attribute</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td>cookbook</td>
    <td>String</td>
    <td>Name of the cookbook that holds the erb templates</td>
    <td><tt><code>diamond</code></tt></td>
  </tr>
  <tr>
    <td>runit_name</td>
    <td>String</td>
    <td>Name of the runit service to restart when modifying this configuration</td>
    <td><tt><code>diamond</code></tt></td>
  </tr>
  <tr>
    <td>diamond_configuration_source></td>
    <td>String</td>
    <td>Name of the ERB Template used to generate diamond.conf</td>
    <td><tt><code>diamond.conf.erb</code></tt></td>
  </tr>
  <tr>
    <td>diamond_handlers</td>
    <td>Array</td>
    <td>Array of the Handlers to configure Diamond with</td>
    <td><tt><code>["diamond.handler.graphitepickle.GraphitePickleHandler"]</code></tt></td>
  </tr>
  <tr>
    <td>diamond_user</td>
    <td>String</td>
    <td>Name of the user for diamond to run as</td>
  </tr>
  <tr>
    <td>diamond_group</td>
    <td>String</td>
    <td>Name of the group the diamond user will run as</td>
  </tr>
  <tr>
    <td>collectors_config_path</td>
    <td>String</td>
    <td>Path where Diamond will store and retrieve configuration files for the Collectors</td>
    <td><tt><code>/opt/diamond/etc/diamond/collectors</code></tt></td>
  </tr>
  <tr>
    <td>diamond_collectors_path</td>
    <td>String</td>
    <td>Directory where the collectors are installed</td>
    <td><tt><code>/opt/diamond/share/diamond/collectors</code></tt></td>
  </tr>
  <tr>
    <td>archive_handler</td>
    <td>Hash</td>
    <td>Configuration parameters for the archive handler</td>
    <td><tt><code>{  "log_file" => "/var/log/diamond/diamond.log", "days" => 7 }</code></tt></td>
  </tr>
  <tr>
    <td>graphite_handler</td>
    <td>Hash</td>
    <td>Configuration parameters for the graphite handler</td>
    <td><tt><code>{ "host" => "localhost", "port" => 2003, "batch" => 256, "timeout" => 15 }</code></tt></td>
  </tr>
  <tr>
    <td>graphite_picklehandler</td>
    <td>Hash</td>
    <td>Configuration parameters for the graphite pickle handler</td>
    <td><tt><code>{ "host" => "localhost", "port" => 2004, "batch" => 256, "timeout" => 15 }</code></tt></td>
  </tr>
  <tr>
    <td>statsdhandler</td>
    <td>Hash</td>
    <td>Configuration parameters for the statsd handler</td>
    <td><tt><code>{ "host" => "127.0.0.1", "port" => 8125 }</code></tt></td>
  </tr>
  <tr>
    <td>tsdbhandler</td>
    <td>Hash</td>
    <td>Configuration parameters for the tsdb handler</td>
    <td><tt><code>{ "host" => "127.0.0.1", "port" => 4242, "timeout" => 15 }</code></tt></td>
  </tr>
  <tr>
    <td>mysqlhandler</td>
    <td>Hash</td>
    <td>Configuration parameters for the mysql handler</td>
    <td><tt><code>{ "host" => "127.0.0.1", "port" => 3306, "username" => String.new, "password" => String.new, "database" => "diamond", "table" => "metrics", "col_time" => "timestamp", "col_metric" => "metric", "col_value" => "value" }</code></tt></td>
  </tr>
  <tr>
    <td>collectors</td>
    <td>Hash</td>
    <td>Configuration for the collectors allowing you to configure suffix, prefix, how to determine hostname and/or set the hostname manually</td>
    <td><tt><code>{ "hostname_method" => "fqdn_short", "hostname" => String.new, "path_prefix" => String.new, "path_suffix" => String.new, "interval" => 300 }</code></tt></td>
  </tr>
</table>

`plugin.rb`
-------------
Enable / Disable plugins with this resource.

Actions:

* `enable` - Creates a configuration file for the collector specified and restarts Diamond
* `disable` - Deletes the configuration file for the collector specified and restarts Diamond

## diamond::plugin

<table>
  <tr>
    <th>Attribute</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td>source</td>
    <td>String</td>
    <td>Name of the ERB Template to be used generating the Collector configuration files</td>
    <td><tt><code>generic_collector_config.conf.erb</code></tt></td>
  </tr>
  <tr>
    <td>cookbook</td>
    <td>String</td>
    <td>Name of the cookbook holding the ERB template for the source attribute</td>
    <td><tt><code>/opt/diamond/etc/diamond/collectors</code></tt></td>
  </tr>
  <tr>
    <td>runit_name</td>
    <td>String</td>
    <td>Name of the runit service to restart when modifying this plugin</td>
    <td><tt><code>diamond</code></tt></td>
  </tr>
  <tr>
    <td>options</td>
    <td>Hash</td>
    <td>Allows you to specify options outside of enabling a collector</td>
  </tr>
</table>

Generic Usage
=====

The following example will just configure Diamond with the `GraphiteHandler` and with the default collectors enabled only.

```ruby
diamond_install "#{node['hostname']}" do  
  action :git  
end  
diamond_configure "#{node['hostname']}" do   
  action :config  
  diamond_handlers [ "diamond.handler.graphite.GraphiteHandler" ]    
  graphite_handler({"host" => "127.0.0.1","port" => 2003, "timeout" => 15})  
end
```  
    
Basic Usage with Plugins
=====

The following example will configure Diamond with the `archive.ArchiveHandler` and `graphite.GraphiteHandler` with the `PingCollector` and `CPUCollector` enabled.

```ruby
diamond_install "#{node['hostname']}" do  
  action :git  
end  
diamond_configure "#{node['hostname']}" do  
  action :config  
  diamond_handlers [ "diamond.handler.archive.ArchiveHandler", "diamond.handler.graphite.GraphiteHandler" ]  
  graphite_handler({"host" => "127.0.0.1","port" => 2003, "timeout" => 15})  
end  
  diamond_plugin "CPUCollector" do  
  action :enable  
  options({})  
end  
  diamond_plugin "PingCollector" do  
  action :enable  
  options({  
    "enabled" => "True",  
    "bin" => "/bin/ping",  
    "use_sudo" => "False",  
    "sudo_cmd" => "/usr/bin/sudo",  
    "target_1" => "google.com",  
    "target_2" => "aol.com"  
    })  
  end  
```

Advanced Usage with Custom Collectors Installed
=====

```ruby
diamond_install "#{node['hostname']}" do  
  action :git  
end  
diamond_configure "#{node['hostname']}" do  
  action :config  
  diamond_handlers [ "diamond.handler.archive.ArchiveHandler", "diamond.handler.graphite.GraphiteHandler" ]  
  graphite_handler({"host" => "127.0.0.1","port" => 2003, "timeout" => 15})  
end  
directory "/usr/local/share/diamond/collectors/latency_http" do  
  action :create  
end  
cookbook_file "/usr/local/share/diamond/collectors/latency_http/latency_http.py" do  
  source "latency_http.py"
  cookbook "our_custom"
end
diamond_plugin "LatencyHTTTPCollector" do  
  action :enable  
  options({  
    "enabled" => "True",  
    "target_1" => "host1.com",  
    "target_2" => "host2.com"  
  })  
end  
```

Author:: Scott M. Likens (<scott@likens.us>)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


