defmodule GameTest do
  use ExUnit.Case
  doctest ExSnake

  test "should wrap around correctly - right" do
    start_pos = %{x: 9, y: 1}
    computed_pos = ExSnake.Game.compute_next_pos(start_pos, :right, 10, 10)

    assert computed_pos.x == 1
  end

  test "should wrap around correctly - left" do
    start_pos = %{x: 0, y: 1}
    computed_pos = ExSnake.Game.compute_next_pos(start_pos, :left, 10, 10)

    assert computed_pos.x == 9
  end

  test "should wrap around correctly - up" do
    start_pos = %{x: 0, y: 0}
    computed_pos = ExSnake.Game.compute_next_pos(start_pos, :up, 10, 10)

    assert computed_pos.y == 9
  end

  test "should wrap around correctly - down" do
    start_pos = %{x: 0, y: 9}
    computed_pos = ExSnake.Game.compute_next_pos(start_pos, :down, 10, 10)

    assert computed_pos.y == 1
  end

  test "should move food to random position if snake is at foods position" do
    initial_state = %ExSnake.UI.State{
      snake: [%{x: 10, y: 10}],
      food: %{x: 10, y: 10}
    }

    computed_state = ExSnake.Game.move_food(initial_state, 20, 20)

    assert Map.equal?(initial_state.food, computed_state.food) == false
  end
end
