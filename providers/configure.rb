action :config do
  template new_resource.prefix + "/etc/diamond/diamond.conf" do
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
                :collectors => new_resource.collectors,
                :prefix => new_resource.prefix
              })
  end
  service "diamond" do
    provider Chef::Provider::Service::Upstart
    action [:stop,:disable]
  end
  file "/etc/init/diamond.conf" do
    action :delete
    only_if { ::File.exists?("/etc/init/diamond.conf") }
  end
  runit_service "diamond" do
    run_template_name "diamond"
    cookbook "diamond"
    default_logger true
    options({
              :prefix => new_resource.prefix
            })
  end
  new_resource.updated_by_last_action(true)
end
