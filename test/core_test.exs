defmodule CoreTest do
  use ExUnit.Case
  doctest ExSnake

  alias ExSnake.Core, as: Core

  describe "next_state" do

    test "should return correct state when not alive" do
      initial_state = %ExSnake.State{
        alive?: false
      }

      next_state = Core.next_state(initial_state)

      assert next_state == %ExSnake.State{
        alive?: true
      }
    end

    test "should return correct state when is about to collide with itself" do
      initial_state = %ExSnake.State{
        snake: [%{x: 9, y: 10}, %{x: 10, y: 10}],
        food: %{x: 20, y: 20},
        direction: :left
      }

      next_state = Core.next_state(initial_state)

      assert next_state == %ExSnake.State{
               snake: [%{x: 9, y: 10}, %{x: 10, y: 10}],
               food: %{x: 20, y: 20},
               direction: :left,
               alive?: false
             }
    end

    test "should return correct state when snake is about to eat food" do
      initial_state = %ExSnake.State{
        snake: [%{x: 9, y: 10}],
        food: %{x: 10, y: 10},
        direction: :right
      }

      next_state = Core.next_state(initial_state)

      assert next_state.snake == [%{x: 9, y: 10}, %{x: 10, y: 10}]
      assert initial_state.food != next_state.food
    end

    test "should return correct state when snake is not about to eat food" do
      initial_state = %ExSnake.State{
        snake: [%{x: 7, y: 10}, %{x: 8, y: 10}],
        food: %{x: 10, y: 10},
        direction: :right
      }

      next_state = Core.next_state(initial_state)

      assert next_state == %ExSnake.State{
               snake: [%{x: 8, y: 10}, %{x: 9, y: 10}],
               food: %{x: 10, y: 10},
               direction: :right
             }
    end

    test "should wrap around correctly when at the edge - right" do
      initial_state = %ExSnake.State{
        snake: [%{x: 9, y: 1}],
        direction: :right,
        window: %{width: 10, height: 10}
      }

      %ExSnake.State{snake: snake} = Core.next_state(initial_state)
      next_head = snake |> Enum.at(length(snake) - 1)
      assert next_head.x == 2
    end

    test "should wrap around correctly when at the edge - left" do
      initial_state = %ExSnake.State{
        snake: [%{x: 1, y: 1}],
        direction: :left,
        window: %{width: 10, height: 10}
      }

      %ExSnake.State{snake: snake} = Core.next_state(initial_state)
      next_head = snake |> Enum.at(length(snake) - 1)
      assert next_head.x == 8
    end

    test "should wrap around correctly - up" do
      initial_state = %ExSnake.State{
        snake: [%{x: 1, y: 1}],
        direction: :up,
        window: %{width: 10, height: 10}
      }

      %ExSnake.State{snake: snake} = Core.next_state(initial_state)
      next_head = snake |> Enum.at(length(snake) - 1)
      assert next_head.y == 9
    end

    test "should wrap around correctly - down" do
      initial_state = %ExSnake.State{
        snake: [%{x: 1, y: 9}],
        direction: :down,
        window: %{width: 10, height: 10}
      }

      %ExSnake.State{snake: snake} = Core.next_state(initial_state)
      next_head = snake |> Enum.at(length(snake) - 1)
      assert next_head.y == 2
    end
  end
end
