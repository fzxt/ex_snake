defmodule ExSnake.Game do
  def next_state(%ExSnake.State{alive?: false}), do: %ExSnake.State{}
  def next_state(state), do: state |> move_snake() |> move_food()

  def move_snake(%ExSnake.State{snake: snake, direction: direction, window: window} = state) do
    next_pos = next_snake_pos(get_head(snake), direction, window)

    case interpret_move(next_pos, state) do
      :collision ->
        %ExSnake.State{state | alive?: false}

      :ate_food ->
        %ExSnake.State{state | snake: snake ++ [next_pos]}

      :didnt_eat ->
        {_, popped} = List.pop_at(snake, 0)
        %ExSnake.State{state | snake: popped ++ [next_pos]}
    end
  end

  def move_food(%ExSnake.State{snake: snake, food: food, window: window} = state) do
    if Map.equal?(get_head(snake), food) do
      %ExSnake.State{state | food: random_pos(window.width - 2, window.height - 2)}
    else
      state
    end
  end

  def next_snake_pos(pos, :right, %{width: width}),
    do: Map.put(pos, :x, limit(pos.x + 1, width - 1))

  def next_snake_pos(pos, :down, %{height: height}),
    do: Map.put(pos, :y, limit(pos.y + 1, height - 1))

  def next_snake_pos(pos, :left, %{width: width}),
    do: Map.put(pos, :x, limit(pos.x - 1, width - 2))

  def next_snake_pos(pos, :up, %{height: height}),
    do: Map.put(pos, :y, limit(pos.y - 1, height - 1))

  ## Private

  defp limit(value, max) when value <= 1, do: max
  defp limit(value, max) when value >= max, do: 2
  defp limit(value, _), do: value

  defp random_pos(width, height), do: %{x: :rand.uniform(width) + 1, y: :rand.uniform(height) + 1}

  defp interpret_move(pos, %ExSnake.State{snake: snake, food: food}) do
    if Enum.member?(snake, pos) do
      :collision
    else
      if(Map.equal?(pos, food), do: :ate_food, else: :didnt_eat)
    end
  end

  defp get_head(snake), do: Enum.at(snake, length(snake) - 1)
end
