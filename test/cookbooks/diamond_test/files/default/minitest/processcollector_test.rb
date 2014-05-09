describe "diamond::test_processcollector" do
  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources
  filename = "/opt/diamond/etc/diamond/collectors/ProcessResourcesCollector.conf"
  it "should have created a config for ProcessResourcesCollector" do
    ::File.exist?(filename)
  end
  it "should have the correct config for ProcessResourcesCollector" do
    shouldbe=<<EOF
### Options for ProcessResourcesCollector
enabled = true
unit = B

[process]

[[diamond]]
selfmon = true

EOF
    File.read(filename) == shouldbe
  end
end
