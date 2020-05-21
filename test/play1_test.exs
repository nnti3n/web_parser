defmodule Play1Test do
  use ExUnit.Case
  doctest Play1

  test "greets the world" do
    assert Play1.hello() == :world
  end
end
