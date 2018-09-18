defmodule ExSnake.IO do
  use GenServer

  @up_arrow "\e[A"
  @down_arrow "\e[B"
  @right_arrow "\e[C"
  @left_arrow "\e[D"

  def init(_args) do
    {:ok, Port.open({:spawn, "tty_sl -c -e"}, [:binary, :eof])}
  end

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: :io)
  end

  ## Server callbacks

  def handle_info({pid, {:data, data}}, pid) do
    case handle_event(data) do
      :right -> Process.send(:ui, {:direction, :right}, [])
      :up -> Process.send(:ui, {:direction, :up}, [])
      :left -> Process.send(:ui, {:direction, :left}, [])
      :down -> Process.send(:ui, {:direction, :down}, [])
      :none -> nil
    end

    {:noreply, pid}
  end

  ## Private, event handlers

  defp handle_event(@up_arrow), do: :up
  defp handle_event(@right_arrow), do: :right
  defp handle_event(@left_arrow), do: :left
  defp handle_event(@down_arrow), do: :down

  defp handle_event("w"), do: :up
  defp handle_event("a"), do: :left
  defp handle_event("s"), do: :down
  defp handle_event("d"), do: :right

  defp handle_event(_), do: :none
end
