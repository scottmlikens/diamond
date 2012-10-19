Description
===========

This cookbook provides providers and resources to configure and manage [Diamond](https://github.com/BrightcoveOS/Diamond) Diamond is a python daemon that collects system metrics and publishes them to Graphite. It is capable of collecting cpu, memory, network, i/o, load and disk metrics. Additionally, it features an API for implementing custom collectors for gathering metrics from almost any source.

Requirements
============

Requires Chef 0.7.10 or higher for Lightweight Resource and Provider support. Chef 0.8+ is recommended. While this cookbook can be used in `chef-solo` mode, to gain the most flexibility, we recommend using `chef-client` with a Chef Server.

Recipes
=======

The example recipe installs [Diamond](https://github.com/BrightcoveOS/Diamond) in the most basic of configurations

Installation Prefix problems
=======================

* `diamond_collectors_path` and `diamond_installation_path` exist in the *configure* resource because on how you install [distutils](http://docs.python.org/library/distutils.html) [Diamond](https://github.com/BrightcoveOS/Diamond) will install its *collectors* in `/usr/local/share/diamond/collectors` instead of `/usr/share/diamond/collectors`.  If your OS/Distribution installs the *collectors* in `/usr/share/diamond/collectors` you should set this accordingly.

Feel free to submit pull requests that can improve this problem.

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
* `deb` - Clones the source from [Github](https://github.com/BrightcoveOS/Diamond.git) and installs using `make builddeb`

Attribute Parameters:

* `name` - String - non-unique name to give your installation.  diamond or using `#{node['hostname']}` 
* `options` - Hash - not required
* `git_repository_uri` - String - default - `https://github.com/BrightcoveOS/Diamond.git`
* `git_reference` - String - default - `master`
* `required_python_packages` - Hash - default - `{ "configobj" => "4.7.2","psutil" => "0.6.1"}`
* `required_debian_packages` - Array - default - `["pbuilder","python-mock","python-configobj","cdbs"]`
* `cookbook` - String - default - `diamond`

`configure.rb`
-------------
Configure Diamond with this resource.

Actions:

* `config` - Creates `/etc/diamond/diamond.conf`

Attribute Parameters:

* `name` - String - non-unique name to give your installation.  diamond or using `#{node['hostname']}` 
* `cookbook` - String - default - `diamond`
* `options` - Hash - not required
* `diamond_installation_path` - String - default - `/usr/local`
* `diamond_configuration_path` - String - default - `/etc/diamond`
* `diamond_configuration_source` - String - default -  `diamond.conf.erb`
* `diamond_init_source` - String - `diamond.erb`
* `diamond_handlers` - Array -default - `["diamond.handler.graphitepickle.GraphitePickleHandler"]`
* `diamond_user` - String
* `diamond_group` - String
* `diamond_pidfile` - String, - default - `/var/run/diamond.pid`
* `collectors_config_path` - String - default - `/etc/diamond/collectors/`
* `diamond_collectors_path` - String - default => `/usr/local/share/diamond/collectors/`
* `collectors_reload_interval` - Fixnum - default - `3600`
* `archive_handler` - Hash - default - `{  "log_file" => "/var/log/diamond/diamond.log", "days" => 7 }`
* `graphite_handler` - Hash - default - `{ "host" => "localhost", "port" => 2003, "batch" => 256, "timeout" => 15 }`
* `graphite_picklehandler` - Hash - default - `{ "host" => "localhost", "port" => 2004, "batch" => 256, "timeout" => 15 }`
* `statsdhandler` - Hash - default - `{ "host" => "127.0.0.1", "port" => 8125 }`
* `tsdbhandler` - Hash - default - `{ "host" => "127.0.0.1", "port" => 4242, "timeout" => 15 }`
* `mysqlhandler` - Hash - default - `{ "host" => "127.0.0.1", "port" => 3306, "username" => String.new, "password" => String.new, "database" => "diamond", "table" => "metrics", "col_time" => "timestamp", "col_metric" => "metric", "col_value" => "value" }`
* `collectors` - Hash - default - `{ "hostname_method" => "fqdn_short", "hostname" => String.new, "path_prefix" => String.new, "path_suffix" => String.new, "interval" => 300 }`

`plugin.rb`
-------------
Enable / Disable plugins with this resource.

Actions:

* `name` - String - name of plugin to enable / disable
* `options` - Hash - required - *see usage*
* `source` - String - default - `generic_collector_config.conf.erb`
* `cookbook` - String - default - `diamond`
* `collectors_path` - String - `default` `/etc/diamond/collectors/`

Generic Usage
=====

The following example will just configure Diamond with the `GraphiteHandler` and with the default collectors enabled only.

    diamond_install "#{node['hostname']}" do  
      action :git  
    end  
    diamond_configure "#{node['hostname']}" do   
      action :config  
      diamond_handlers [ "diamond.handler.graphite.GraphiteHandler" ]    
      graphite_handler({"host" => "127.0.0.1","port" => 2003, "timeout" => 15})  
    end  
    
Basic Usage with Plugins
=====

The following example will configure Diamond with the `archive.ArchiveHandler` and `graphite.GraphiteHandler` with the `PingCollector` and `CPUCollector` enabled.

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

Advanced Usage with Custom Collectors Installed
=====

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


