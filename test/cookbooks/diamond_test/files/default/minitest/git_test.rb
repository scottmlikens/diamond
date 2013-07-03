describe "diamond::test_tarball" do
  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources
  it "should have a directory called /opt/diamond" do
    directory("/opt/diamond").must_exist
  end
  it "should have a file called /opt/diamond/bin/activate" do
    file("/opt/diamond/bin/activate").must_exist
  end
  it "should have a file called /opt/diamond/bin/diamond" do
    file("/opt/diamond/bin/diamond").must_exist
  end
  it "should be running" do
    service("diamond").must_be_running
  end
end
