defmodule ExSnake.Game do
  def move_snake(state, width, height) do
    # to move the snake, we remove the first node(head), add to the last node (tail)
    next_pos = compute_next_pos(Enum.at(state.snake, 0), state.direction, width, height)
    {_, popped} = List.pop_at(state.snake, 0)
    %ExSnake.UI.State{state | snake: popped ++ [next_pos]}
  end

  def move_food(state) do
    state
  end

  def compute_next_pos(pos, :right, width, _), do: Map.put(pos, :x, mod(pos.x + 1, width))
  def compute_next_pos(pos, :left, width, _), do: Map.put(pos, :x, mod(pos.x - 1, width))
  def compute_next_pos(pos, :down, _, height), do: Map.put(pos, :y, mod(pos.y + 1, height))
  def compute_next_pos(pos, :up, _, height), do: Map.put(pos, :y, mod(pos.y - 1, height))

  defp mod(x,y) when x > 0, do: add_one(rem(x, y));
  defp mod(x,y) when x < 0, do: add_one(y + rem(x, y));
  defp mod(0,_), do: 0

  defp add_one(rem) when rem <= 0, do: rem + 1
  defp add_one(rem), do: rem
end
