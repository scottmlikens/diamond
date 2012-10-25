actions :config

attribute :cookbook, :kind_of => String, :default => "diamond"
attribute :options, :kind_of => Hash
attribute :diamond_installation_path, :kind_of => String, :default => "/usr/local"
attribute :diamond_configuration_path, :kind_of => String, :default => "/etc/diamond"
attribute :diamond_configuration_source, :kind_of => String, :default => "diamond.conf.erb"
attribute :diamond_init_source, :kind_of => String, :default => "diamond.erb"
attribute :diamond_handlers, :kind_of => Array, :default => ["diamond.handler.graphitepickle.GraphitePickleHandler"]
attribute :diamond_user, :kind_of => String
attribute :diamond_group, :kind_of => String
attribute :diamond_pidfile, :kind_of => String, :default => "/var/run/diamond.pid"
attribute :collectors_config_path, :kind_of => String, :default => "/etc/diamond/collectors/"
attribute :diamond_collectors_path, :kind_of => String, :default => "/usr/local/share/diamond/collectors/"
attribute :collectors_reload_interval, :kind_of => Fixnum, :default => 3600
attribute :archive_handler, :kind_of => Hash, :default => {  "log_file" => "/var/log/diamond/diamond.log", "days" => 7 }
attribute :graphite_handler, :kind_of => Hash, :default => { "host" => "localhost", "port" => 2003, "batch" => 256, "timeout" => 15 }
attribute :graphite_picklehandler, :kind_of => Hash, :default => { "host" => "localhost", "port" => 2004, "batch" => 256, "timeout" => 15 }
attribute :statsdhandler, :kind_of => Hash, :default => { "host" => "127.0.0.1", "port" => 8125 }
attribute :tsdbhandler, :kind_of => Hash, :default => { "host" => "127.0.0.1", "port" => 4242, "timeout" => 15 }
attribute :mysqlhandler, :kind_of => Hash, :default => { "host" => "127.0.0.1", "port" => 3306, "username" => String.new, "password" => String.new, "database" => "diamond", "table" => "metrics", "col_time" => "timestamp", "col_metric" => "metric", "col_value" => "value" } 
attribute :collectors, :kind_of => Hash, :default => { "hostname_method" => "fqdn_short", "hostname" => String.new, "path_prefix" => String.new, "path_suffix" => String.new, "interval" => 300 }
 
def initialize(*args)
  super
  @action = :create
  @run_context.include_recipe ["build-essential","git","python","python::pip"]
end

