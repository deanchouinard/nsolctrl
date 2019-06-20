defmodule NSolCtrlTest do
  use ExUnit.Case, async: true

  doctest NSolCtrl

  #  setup do
    #  test_server = start_supervised!(TestServer)
    # %{test_server: test_server}
    #end

    #test "adds entries", %{test_server: test_server} do
  test "adds entries" do
    TestServer.put(:first, "one")
    assert TestServer.get(:first) == "one"
  end

  test "greets the world" do
    assert NSolCtrl.hello() == :world
  end
end
