defmodule ExSnake.Game do
  def move_snake(%ExSnake.State{ snake: snake, food: food, direction: direction, window: window } = state) do
    next_pos = compute_next_pos(Enum.at(snake, length(snake) - 1), direction, window)

    if Map.equal?(next_pos, food) do
        %ExSnake.State{state | snake: snake ++ [next_pos]}
    else
      {_, popped} = List.pop_at(snake, 0)
      %ExSnake.State{state | snake: popped ++ [next_pos]}
    end
  end

  def move_food(%ExSnake.State{ food: food, snake: snake, window: window } = state) do
    if Map.equal?(Enum.at(snake, length(snake) - 1), food) do
      %ExSnake.State{ state | food: random_pos(window.width - 1, window.height - 1) }
    else
      state
    end
  end

  def compute_next_pos(pos, :right, %{ width: width }), do: Map.put(pos, :x, mod(pos.x + 1, width))
  def compute_next_pos(pos, :left, %{ width: width }), do: Map.put(pos, :x, mod(pos.x - 1, width))
  def compute_next_pos(pos, :down, %{ height: height }), do: Map.put(pos, :y, mod(pos.y + 1, height))
  def compute_next_pos(pos, :up, %{ height: height }), do: Map.put(pos, :y, mod(pos.y - 1, height))

  defp mod(x,y) when x > 0, do: add_one(rem(x, y));
  defp mod(x,y) when x < 0, do: add_one(y + rem(x, y));
  defp mod(0,_), do: 0

  defp add_one(rem) when rem <= 0, do: rem + 1
  defp add_one(rem), do: rem

  defp random_pos(width, height), do: %{ x: :rand.uniform(width), y: :rand.uniform(height) }
end
