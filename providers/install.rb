# Installs Diamond via Github using the git interface
#
#    diamond_install node['hostname'] do  
#     action :git
#    end

action :git do
  git Chef::Config[:file_cache_path] + "/" + new_resource.name do
    repository new_resource.git_repository_uri
    reference new_resource.git_reference
    action :checkout
    not_if { ::File.exists?("#{new_resource.prefix}/bin/diamond") }
  end
  directory new_resource.prefix do
    action :create
    mode 0755
  end
  python_virtualenv new_resource.prefix do
    action :create
  end
  new_resource.required_python_packages.collect do |pkg, ver|
    python_pip pkg do
      version ver
      virtualenv new_resource.prefix
      action :install
    end
  end
  execute "create version.txt" do
    cwd Chef::Config[:file_cache_path] + "/" + new_resource.name
    command "/bin/bash version.sh > version.txt"
    not_if { ::File.exists?("#{new_resource.prefix}/bin/diamond") }
  end
  script "install diamond in virtualenv #{new_resource.prefix}" do
    interpreter "bash"
    environment("VIRTUAL_ENV" => new_resource.prefix,
                "PATH" => new_resource.prefix + "/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin")
    cwd Chef::Config[:file_cache_path] + "/" + new_resource.name
    code <<-EOH
    python setup.py install
    EOH
    not_if { ::File.exists?("#{new_resource.prefix}/bin/diamond") }
    creates new_resource.prefix + "/bin/diamond"
  end
  
  ["/var/log/diamond/",new_resource.prefix + "/share/diamond",new_resource.prefix + "/share/diamond/collectors"].each do |dp|
    directory dp do
      action :create
      recursive true
    end
  end
  new_resource.updated_by_last_action(true)
end

# Installs Diamond via Github using a tarball
#
#    diamond_install node['hostname'] do  
#     action :tarball
#    end

action :tarball do
  directory new_resource.prefix do
    action :create
    mode 0755
  end
  python_virtualenv new_resource.prefix do
    action :create
  end
  execute "wget -O #{Chef::Config[:file_cache_path]}/diamond.tar.gz #{new_resource.tarball_path}" do
    action :run
    not_if { ::File.exists?(Chef::Config[:file_cache_path] + "/diamond.tar.gz") }
  end
  directory Chef::Config[:file_cache_path] + "/" + new_resource.tarball_extract_fldr do
    action :create
    mode 0755
  end
  script "extract tarball" do
    interpreter "bash"
    code "tar -C " + Chef::Config[:file_cache_path] + "/" + new_resource.tarball_extract_fldr + " -xzf " + Chef::Config[:file_cache_path] + "/diamond.tar.gz"
    not_if { ::File.exists?("/opt/diamond/bin/diamond") }
  end
  new_resource.required_python_packages.collect do |pkg, ver|
    python_pip pkg do
      version ver
      action :install
      virtualenv new_resource.prefix
    end
  end
  execute "create version.txt" do
    cwd Chef::Config[:file_cache_path] + "/" + new_resource.tarball_extract_fldr + "/" + new_resource.tarball_extract_fldr
    command "/bin/bash version.sh > version.txt"
    not_if { ::File.exists?("/opt/diamond/bin/diamond") }
  end
  script "install diamond in virtualenv #{new_resource.prefix}" do
    interpreter "bash"
    environment("VIRTUAL_ENV" => new_resource.prefix,
                "PATH" => new_resource.prefix + "/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin")
    cwd Chef::Config[:file_cache_path] + "/" + new_resource.tarball_extract_fldr + "/" + new_resource.tarball_extract_fldr
    code <<-EOH
    python setup.py install
    EOH
    creates new_resource.prefix + "/bin/diamond"
  end
  ["/var/log/diamond/",new_resource.prefix + "/share/diamond",new_resource.prefix + "/share/diamond/collectors"].each do |dp|
    directory dp do
      action :create
      recursive true
    end
  end
  new_resource.updated_by_last_action(true)
end
