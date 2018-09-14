defmodule ExSnake.Gui.Window do
    use GenServer

    @refresh_interval 500

    def start_link do
        GenServer.start_link(__MODULE__, %ExSnake.Gui.State{}, name: :window)
    end

    ## Server callbacks

    def init(state) do
        { width, height } = get_terminal_dimensions()

        state = %ExSnake.Gui.State{ state | rows: height - 5, cols: width - 1 }

        [IO.ANSI.clear, IO.ANSI.home, draw_borders(state.rows, trunc(state.cols / 2))]
        |> IO.write

        schedule_next_tick()

        {:ok, state}
    end

    def handle_info(:tick, state) do
        { width, height } = get_terminal_dimensions()

        if (state.cols != width || state.rows != height) do
            state = %ExSnake.Gui.State{ state | rows: height - 5, cols: width - 1 }
            [IO.ANSI.clear, IO.ANSI.home, draw_borders(state.rows, trunc(state.cols / 2))]
            |> IO.write
        end

        schedule_next_tick()
        {:noreply, state}
    end

    ## Client APIs

    def schedule_next_tick() do
        Process.send_after(self(), :tick, @refresh_interval)
    end

    ## Private

    def draw_borders(height, width) do
        Enum.map(1..height, fn row->
            Enum.map(1..width, fn col->
                draw_border(row, col, height, width)
            end)
        end)
    end

    defp move_cursor(row, col), do: IO.ANSI.format ["\e[#{trunc(row)};#{trunc(col)}f"]
    # first row, any column
    defp draw_border(1, col, _, _),   do: draw_border_cell(1, col)
    # first column, any row
    defp draw_border(row, 1, _, _),   do: draw_border_cell(row, 1)
    # last row or last column
    defp draw_border(row, col, height, width) when row == height or col == width,  do: draw_border_cell(row, col)
    # everything else
    defp draw_border(_, _, _, _),     do: ''

    defp draw_border_cell(row, col) do
        [move_cursor(row, col * 2), ' * ']
    end

    defp get_terminal_dimensions do
        {:ok,width} = :io.columns
        {:ok,height} = :io.rows
        {width, height}
    end
end