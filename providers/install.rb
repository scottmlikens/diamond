action :git do
  python_pip "diamond" do
    action :remove
    only_if { ::File.exists?("/usr/local/lib/python2.7/dist-packages/diamond/version.py") }
  end
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
  directory new_resource.prefix do
    action :create
    mode 0755
  end
  python_virtualenv new_resource.prefix do
    action :create
  end
  new_resource.required_python_packages.collect do |pkg, ver|
    python_pip "#{pkg}" do
      version ver
      virtualenv new_resource.prefix
      action :install
    end
  end

  execute "create version.txt" do
    cwd "/mnt/git/#{new_resource.name}"
    command "/bin/bash version.sh > version.txt"
    not_if { ::File.exists?("/usr/local/bin/diamond") }
  end

  script "install diamond in virtualenv #{new_resource.prefix}" do
    interpreter "bash"
    environment("VIRTUAL_ENV" => new_resource.prefix,
                "PATH" => new_resource.prefix + "/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin")
    cwd "/mnt/git/#{new_resource.name}"
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
  
  directory "clean up temp git path" do
    path "/mnt/git/#{new_resource.name}"
    action :delete
    recursive true
  end
  new_resource.updated_by_last_action(true)
end

action :tarball do
  python_pip "diamond" do
    action :remove
    only_if { ::File.exists?("/usr/local/lib/python2.7/dist-packages/diamond/version.py") }
  end
  directory new_resource.prefix do
    action :create
    mode 0755
  end
  python_virtualenv new_resource.prefix do
    action :create
  end
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
      virtualenv new_resource.prefix
    end
  end

  execute "create version.txt" do
    cwd "/mnt/diamond_tarball/#{new_resource.tarball_extract_fldr}"
    command "/bin/bash version.sh > version.txt"
    not_if { ::File.exists?("/usr/local/bin/diamond") }
  end

  script "install diamond in virtualenv #{new_resource.prefix}" do
    interpreter "bash"
    environment("VIRTUAL_ENV" => new_resource.prefix,
                "PATH" => new_resource.prefix + "/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin")
    cwd "/mnt/diamond_tarball/#{new_resource.tarball_extract_fldr}"
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

  directory "clean up temp extract path" do
    path "/mnt/diamond_tarball/#{new_resource.tarball_extract_fldr}"
    action :delete
    recursive true
  end
  new_resource.updated_by_last_action(true)
end
