defmodule ExSnake.Core do
  @moduledoc """
  Computes next states for the game.
  """

  @spec next_state(ExSnake.State.t()) :: ExSnake.State.t()
  def next_state(%ExSnake.State{alive?: false}), do: %ExSnake.State{}

  def next_state(state) do
    state
    |> next_snake()
    |> next_food()
  end

  ## Private

  defp next_snake(%ExSnake.State{snake: snake} = state) do
    snake
    |> get_head()
    |> next_snake_pos(state)
    |> interpret_move(state)
    |> handle_move()
  end

  defp next_food(%ExSnake.State{snake: snake} = state) do
    snake
    |> get_head()
    |> ate_food?(state)
    |> generate_food(state)
  end

  defp next_snake_pos(pos, %ExSnake.State{direction: :right, window: %{width: width}}),
    do: Map.put(pos, :x, limit(pos.x + 1, width - 1))

  defp next_snake_pos(pos, %ExSnake.State{direction: :down, window: %{height: height}}),
    do: Map.put(pos, :y, limit(pos.y + 1, height - 1))

  defp next_snake_pos(pos, %ExSnake.State{direction: :left, window: %{height: width}}),
    do: Map.put(pos, :x, limit(pos.x - 1, width - 2))

  defp next_snake_pos(pos, %ExSnake.State{direction: :up, window: %{height: height}}),
    do: Map.put(pos, :y, limit(pos.y - 1, height - 1))

  defp limit(value, max) when value <= 1, do: max
  defp limit(value, max) when value >= max, do: 2
  defp limit(value, _), do: value

  defp random_pos(width, height), do: %{x: :rand.uniform(width) + 1, y: :rand.uniform(height) + 1}

  defp generate_food(false, state), do: state

  defp generate_food(true, %ExSnake.State{window: window} = state),
    do: %ExSnake.State{state | food: random_pos(window.width - 3, window.height - 3)}

  defp ate_food?(pos, %ExSnake.State{food: food}), do: Map.equal?(pos, food)
  defp collided?(pos, %ExSnake.State{snake: snake}), do: Enum.member?(snake, pos)

  defp interpret_move(pos, state) do
    cond do
      collided?(pos, state) -> {:collision, pos, state}
      ate_food?(pos, state) -> {:ate_food, pos, state}
      true -> {:didnt_eat, pos, state}
    end
  end

  defp get_head(snake), do: Enum.at(snake, length(snake) - 1)

  defp handle_move({:collision, _, state}), do: %ExSnake.State{state | alive?: false}

  defp handle_move({:ate_food, next_pos, %ExSnake.State{snake: snake} = state}),
    do: %ExSnake.State{state | snake: snake ++ [next_pos]}

  defp handle_move({:didnt_eat, next_pos, %ExSnake.State{snake: snake} = state}) do
    {_, popped} = List.pop_at(snake, 0)
    %ExSnake.State{state | snake: popped ++ [next_pos]}
  end
end
