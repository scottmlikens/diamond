action :git do
  directory "create temp git path" do
    path "/mnt/git/#{new_resource.name}" 
    action :create
    recursive true
  end
  
  git "/mnt/git/#{new_resource.name}" do
    repository new_resource.git_repository_uri
    reference new_resource.git_reference
    action :checkout
    not_if { ::File.exists?("/usr/local/bin/diamond") || ::File.exists?("/mnt/git/Diamond/setup.py") }
  end

  new_resource.required_python_packages.collect do |pkg, ver|
    python_pip "#{pkg}" do
      version ver
      action :install
    end
  end

  execute "create version.txt" do
    cwd "/mnt/git/#{new_resource.name}"
    command "/bin/bash version.sh > version.txt"
    not_if { ::File.exists?("/usr/local/bin/diamond") }
  end

  execute "install diamond" do
    cwd "/mnt/git/#{new_resource.name}"
    command "python setup.py install"
    creates "/usr/local/bin/diamond"
  end

  ["/var/log/diamond/","/usr/local/share/diamond","/usr/share/diamond/collectors"].each do |dp|
    directory dp do
      action :create
      recursive true
    end
  end
  
  directory "clean up temp git path" do
    path "/mnt/git/#{new_resource.name}"
    action :delete
    recursive true
  end
  new_resource.updated_by_last_action(true)
end

action :deb do
  directory "create temp git path" do
    path "/mnt/git/#{new_resource.name}" 
    action :create
    recursive true
  end
  
  git "/mnt/git/#{new_resource.name}" do
    repository new_resource.git_repository_uri
    reference new_resource.git_reference
    action :checkout
    not_if { ::File.exists?("/usr/bin/diamond") || ::File.exists?("/mnt/git/Diamond/setup.py") }
  end

  new_resource.required_debian_packages.collect do |pkg|
    package "#{pkg}"
  end
    
  execute "build diamond" do
    cwd "/mnt/git/#{new_resource.name}"
    command "make builddeb"
  end

  ["/var/log/diamond/","/usr/local/share/diamond","/usr/share/diamond"].each do |dp|
    directory dp do
      action :create
    end
  end

  package "#{remotes}" do
    source "/mnt/git/#{new_resource.name}/build/diamond_3.0.2_all.deb"
    provider Chef::Provider::Package::Dpkg
    action :install
  end

  directory "clean up temp git path" do
    path "/mnt/git/#{new_resource.name}"
    action :delete
    recursive true
  end
  new_resource.updated_by_last_action(true)
end

action :tarball do
  directory "create temp extract path" do
    path "/mnt/diamond_tarball"
    action :create
    recursive true
  end

  remote_file "/mnt/diamond_tarball/diamond.tar.gz" do
    source new_resource.tarball_path
    backup false
    mode "0644"
    action :create_if_missing
    not_if { ::File.exists?("/usr/local/bin/diamond") || ::File.exists?("/mnt/diamond_tarball/#{new_resource.tarball_extract_fldr}/setup.py") }
  end

  script "extract tarball" do
    interpreter "bash"
    code "tar -C /mnt/diamond_tarball -xzf /mnt/diamond_tarball/diamond.tar.gz"
    not_if { ::File.exists?("/usr/local/bin/diamond") || ::File.exists?("/mnt/diamond_tarball/#{new_resource.tarball_extract_fldr}/setup.py") }
  end

  new_resource.required_python_packages.collect do |pkg, ver|
    python_pip "#{pkg}" do
      version ver
      action :install
    end
  end

  execute "create version.txt" do
    cwd "/mnt/diamond_tarball/#{new_resource.tarball_extract_fldr}"
    command "/bin/bash version.sh > version.txt"
    not_if { ::File.exists?("/usr/local/bin/diamond") }
  end

  execute "install diamond" do
    cwd "/mnt/diamond_tarball/#{new_resource.tarball_extract_fldr}"
    command "python setup.py install"
    creates "/usr/local/bin/diamond"
  end

  ["/var/log/diamond/","/usr/local/share/diamond","/usr/share/diamond/collectors"].each do |dp|
    directory dp do
      action :create
      recursive true
    end
  end

  directory "clean up temp extract path" do
    path "/mnt/diamond_tarball/#{new_resource.tarball_extract_fldr}"
    action :delete
    recursive true
  end
  new_resource.updated_by_last_action(true)
end
