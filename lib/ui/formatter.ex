defmodule ExSnake.UI.Formatter do
  @mid_bar "\u2500"
  @vert_line "\u2502"
  @top_left_corner "\u250c"
  @top_right_corner "\u2510"
  @bottom_left_corner "\u2514"
  @bottom_right_corner "\u2518"

  def draw_walls(%ExSnake.State{window: window}) do
    [
      top_bar(window.width - 1),
      vert_lines(window.height - 1, window.width - 1),
      bottom_bar(window.width - 1)
    ]
  end

  def vert_lines(height, width) do
    Enum.map(1..height, fn row ->
      Enum.map(1..width, fn col ->
        draw_vert_line(row, col, width)
      end)
    end)
  end

  def move_cursor(row, col) do
    IO.ANSI.format(["\e[#{trunc(row)};#{trunc(col)}f"])
  end

  def draw_snake(%ExSnake.State{snake: snake}) do
    Enum.map(snake, fn piece ->
      draw_snake_piece(piece)
    end)
  end

  def draw_food(%ExSnake.State{food: pos}) do
    draw_food_piece(pos)
  end

  def reset_cursor() do
    move_cursor(0, 0)
  end

  def undraw_snake_tail(%ExSnake.State{snake: snake}) do
    undraw_cell(Enum.at(snake, 0))
  end

  def undraw_snake(%ExSnake.State{snake: snake}) do
      Enum.map(snake, fn piece ->
        undraw_cell(piece)
      end)
  end

  def undraw_food(%ExSnake.State{food: food}) do
    undraw_cell(food)
  end

  ## Private

  defp undraw_cell(coord), do: [move_cursor(coord.y, coord.x * 2), '  ']

  defp draw_vert_line(_, 1, _), do: @vert_line
  defp draw_vert_line(_, col, width) when col == width, do: "    #{@vert_line}\n"
  defp draw_vert_line(_, _, _), do: '  '

  defp top_bar(width) do
    [@top_left_corner, String.duplicate("#{@mid_bar}#{@mid_bar}", width), @top_right_corner, "\n"]
  end

  defp bottom_bar(width) do
    [
      @bottom_left_corner,
      String.duplicate("#{@mid_bar}#{@mid_bar}", width),
      @bottom_right_corner,
      "\n"
    ]
  end

  defp draw_snake_piece(coord) do
    [move_cursor(coord.y, coord.x * 2), ' x ']
  end

  defp draw_food_piece(coord) do
    [move_cursor(coord.y, coord.x * 2), ' o ']
  end
end
