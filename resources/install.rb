actions :git, :tarball

attribute :prefix, :kind_of => String, :default => "/opt/diamond"
attribute :git_repository_uri, :kind_of => String, :default => "https://github.com/BrightcoveOS/Diamond.git"
attribute :git_reference, :kind_of => String, :default => "master"
attribute :required_python_packages, :kind_of => Hash, :default => { "configobj" => "4.7.2","psutil" => "0.6.1"}
attribute :cookbook, :kind_of => String, :default => "diamond"
attribute :tarball_path, :kind_of => String, :default => "https://github.com/BrightcoveOS/Diamond/archive/master.tar.gz"
attribute :tarball_extract_fldr, :kind_of => String, :default => "Diamond-master"

def initialize(*args)
  super
  @action = :create
  @run_context.include_recipe ["build-essential","git","python","python::pip","python::virtualenv","runit::default"]
end

