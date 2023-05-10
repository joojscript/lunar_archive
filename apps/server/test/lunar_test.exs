defmodule LunarTest do
  use ExUnit.Case
  doctest Lunar

  test "greets the world" do
    assert Lunar.hello() == :world
  end
end
