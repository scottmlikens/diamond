describe "diamond::test_custom_install" do
  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources
  it "should have a directory called /opt/custom_diamond" do
    directory("/opt/custom_diamond").must_exist
  end
  it "should have a file called /opt/custom_diamond/bin/activate" do
    file("/opt/custom_diamond/bin/activate").must_exist
  end
  it "should have a file called /opt/custom_diamond/bin/diamond" do
    file("/opt/custom_diamond/bin/diamond").must_exist
  end
  it "should have a file called /opt/custom_diamond/etc/diamond/collectors/NetworkCollector" do
    file("/opt/custom_diamond/etc/diamond/collectors/NetworkCollector").must_exist
  end
  it "should be running" do
    service("custom_diamond").must_be_running
  end
end
