defmodule ExSnake.Grid do
    use GenServer

    @refresh_interval 500

    def start_link do
        GenServer.start_link(__MODULE__, %ExSnake.Grid.State{}, name: :window)
    end

    ## Server callbacks

    def init(state) do
        [
            IO.ANSI.clear,
            IO.ANSI.home,
            ExSnake.Grid.Formatter.draw_walls(state.rows, state.cols),
            ExSnake.Grid.Formatter.reset_cursor
        ]
        |> IO.write

        schedule_next_tick()

        {:ok, state}
    end

    def handle_info(:tick, state) do
        schedule_next_tick()
        {:noreply, state}
    end

    ## Private

    defp schedule_next_tick() do
        Process.send_after(self(), :tick, @refresh_interval)
    end
end
