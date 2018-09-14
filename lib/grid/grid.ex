defmodule ExSnake.Grid do

    use GenServer

    @refresh_interval 500

    def start_link do
        GenServer.start_link(__MODULE__, %ExSnake.Grid.State{}, name: :window)
    end

    ## Server callbacks

    def init(state) do
        { width, height } = get_terminal_dimensions()

        state = %ExSnake.Grid.State{ state | rows: height - 5, cols: width - 1 }

        [
            IO.ANSI.clear,
            IO.ANSI.home,
            ExSnake.Grid.Formatter.draw_grid(state.rows, state.cols),
        ]
        |> IO.write

        schedule_next_tick()

        {:ok, state}
    end

    def handle_info(:tick, state) do
        if resized_window(state) do
            { width, height } = get_terminal_dimensions()
            state = %ExSnake.Grid.State{ state | rows: height - 5, cols: width - 1 }
            [IO.ANSI.clear, IO.ANSI.home, ExSnake.Grid.Formatter.draw_grid(state.rows, state.cols)]
            |> IO.write
        end

        schedule_next_tick()
        {:noreply, state}
    end

    ## Private

    defp schedule_next_tick() do
        Process.send_after(self(), :tick, @refresh_interval)
    end

    defp get_terminal_dimensions do
        {:ok,width} = :io.columns
        {:ok,height} = :io.rows
        {width, height}
    end

    defp resized_window(state) do
        { width, height } = get_terminal_dimensions()
        state.cols != width or state.rows != height
    end
end