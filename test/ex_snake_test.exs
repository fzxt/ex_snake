defmodule ExSnakeTest do
  use ExUnit.Case
  doctest ExSnake

  test "greets the world" do
    assert ExSnake.hello() == :world
  end
end
