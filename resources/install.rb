actions :git, :deb

attribute :options, :kind_of => Hash
attribute :git_repository_uri, :kind_of => String, :default => "https://github.com/BrightcoveOS/Diamond.git"
attribute :git_reference, :kind_of => String, :default => "master"
attribute :required_python_packages, :kind_of => Hash, :default => { "configobj" => "4.7.2","psutil" => "0.6.1"}
attribute :required_debian_packages, :kind_of => Array, :default => ["pbuilder","python-mock","python-configobj","cdbs"]
attribute :cookbook, :kind_of => String, :default => "diamond"

def initialize(*args)
  super
  @action = :create
  @run_context.include_recipe ["build-essential","git","python","python::pip"]
end

