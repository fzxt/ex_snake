defmodule ExSnake.Game do
  def move_snake(state) do
    # to move the snake, we remove the first node(head), add to the last node (tail)
    next_pos = compute_next_pos(Enum.at(state.snake, 0), state.direction)
    { _, popped } = List.pop_at(state.snake, 0)
    %ExSnake.UI.State{ state | snake: popped ++ [next_pos] }
  end

  def compute_next_pos(pos, :right), do: Map.put(pos, :x, pos.x + 1)
  def compute_next_pos(pos, :left), do: Map.put(pos, :x, pos.x - 1)
  def compute_next_pos(pos, :down), do: Map.put(pos, :y, pos.y + 1)
  def compute_next_pos(pos, :up), do: Map.put(pos, :y, pos.y - 1)
end
