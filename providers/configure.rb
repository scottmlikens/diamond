action :config do
  template "#{new_resource.diamond_configuration_path}/diamond.conf" do
    source new_resource.diamond_configuration_source
    mode 0644
    owner "root"
    group "root"
    variables({
              :diamond_handlers => new_resource.diamond_handlers,
              :user => new_resource.diamond_user,
              :group => new_resource.diamond_group,
              :pidfile => new_resource.diamond_pidfile,
              :collectors_path => new_resource.diamond_collectors_path,
              :collectors_config_path => new_resource.collectors_config_path,
              :reload_interval => new_resource.collectors_reload_interval,
              :archive_handler => new_resource.archive_handler,
              :graphite_handler => new_resource.graphite_handler,
              :graphite_picklehandler => new_resource.graphite_picklehandler,
              :statsdhandler => new_resource.statsdhandler,
              :mysqlhandler => new_resource.mysqlhandler,
              :tsdbhandler => new_resource.tsdbhandler,
              :collectors => new_resource.collectors
              })
  end
  template "/etc/init/diamond.conf" do
    source new_resource.diamond_init_source
    mode 0755
    owner "root"
    group "root"
    variables({
                :path_to_diamond => new_resource.diamond_installation_path
              })
  end
  service "diamond" do
    provider Chef::Provider::Service::Upstart
    action :start
  end
  new_resource.updated_by_last_action(true)
end
