defmodule ExSnake.UI.Formatter do
    @height 30
    @width 50

    @mid_bar "\u2500"
    @vert_line "\u2502"
    @top_left_corner "\u250c"
    @top_right_corner "\u2510"
    @bottom_left_corner "\u2514"
    @bottom_right_corner "\u2518"

    def draw_walls() do
        [
            top_bar(@width),
            vert_lines(@height, @width),
            bottom_bar(@width)
        ]
    end

    def vert_lines(height, width) do
        Enum.map(1..height, fn row ->
            Enum.map(1..width, fn col ->
                draw_vert_line(row, col)
            end)
        end)
    end

    def move_cursor(row, col) do
      IO.ANSI.format ["\e[#{trunc(row)};#{trunc(col)}f"]
    end

    def draw_snake(%ExSnake.UI.State{snake: snake_coords}) do
        Enum.map(snake_coords, fn coord ->
            draw_snake_piece(coord)
        end)
    end

    def reset_cursor() do
      move_cursor(0, 0)
    end

    def undraw_snake_tail(%ExSnake.UI.State{snake: snake_list}) do
      undraw_snake_tail_cell(Enum.at(snake_list, 0))
    end

    ## Private

    defp undraw_snake_tail_cell(%{x: col, y: row}), do: [move_cursor(row, col * 2), '  ', '  ']

    defp draw_vert_line(_, 1), do: @vert_line
    defp draw_vert_line(_, col) when col == @width, do: "  #{@vert_line} \n"
    defp draw_vert_line(_, _), do: ' '

    defp top_bar(width) do
        [@top_left_corner, String.duplicate("#{@mid_bar}", width), @top_right_corner, "\n"]
    end

    defp bottom_bar(width) do
        [@bottom_left_corner, String.duplicate("#{@mid_bar}", width), @bottom_right_corner, "\n"]
    end

    defp draw_snake_piece(coord) do
        [move_cursor(coord.y, coord.x * 2), ' x ']
    end
end
