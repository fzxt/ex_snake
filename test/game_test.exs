defmodule GameTest do
  use ExUnit.Case
  doctest ExSnake

  describe "move_snake" do
    test "should compute correct state when snake is about to eat food" do
      initial_state = %ExSnake.State{
        snake: [%{x: 9, y: 10}],
        food: %{x: 10, y: 10},
        direction: :right,
      }

      next_state = ExSnake.Game.move_snake(initial_state)


      assert next_state == %ExSnake.State{
        snake: [%{x: 9, y: 10}, %{x: 10, y: 10}],
        food: %{x: 10, y: 10},
        direction: :right
      }
    end

    test "should compute correct state when snake is not about to eat food" do
      initial_state = %ExSnake.State{
        snake: [%{x: 7, y: 10}, %{x: 8, y: 10}],
        food: %{x: 10, y: 10},
        direction: :right
      }

      next_state = ExSnake.Game.move_snake(initial_state)

      assert next_state == %ExSnake.State{
        snake: [%{x: 8, y: 10}, %{x: 9, y: 10}],
        food: %{x: 10, y: 10},
        direction: :right
      }
    end
  end

  describe "move_food" do
    test "move_food should return random position if snake is at foods position" do
      initial_state = %ExSnake.State{
        snake: [%{x: 9, y: 10}, %{x: 10, y: 10}],
        food: %{x: 10, y: 10}
      }

      computed_state = ExSnake.Game.move_food(initial_state)

      assert Map.equal?(initial_state.food, computed_state.food) == false
    end
  end

  describe "compute_next_pos" do
    test "compute_next_pos should wrap around correctly - right" do
      start_pos = %{x: 9, y: 1}
      computed_pos = ExSnake.Game.compute_next_pos(start_pos, :right, %{width: 10, height: 10})

      assert computed_pos.x == 1
    end

    test "compute_next_pos should wrap around correctly - left" do
      start_pos = %{x: 0, y: 1}
      computed_pos = ExSnake.Game.compute_next_pos(start_pos, :left, %{width: 10, height: 10})

      assert computed_pos.x == 9
    end

    test "compute_next_pos should wrap around correctly - up" do
      start_pos = %{x: 0, y: 0}
      computed_pos = ExSnake.Game.compute_next_pos(start_pos, :up, %{width: 10, height: 10})

      assert computed_pos.y == 9
    end

    test "compute_next_pos should wrap around correctly - down" do
      start_pos = %{x: 0, y: 9}
      computed_pos = ExSnake.Game.compute_next_pos(start_pos, :down, %{width: 10, height: 10})

      assert computed_pos.y == 1
    end
  end
end
