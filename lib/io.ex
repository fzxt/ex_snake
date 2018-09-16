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

  def handle_event(@up_arrow), do: :up
  def handle_event(@right_arrow), do: :right
  def handle_event(@left_arrow), do: :left
  def handle_event(@down_arrow), do: :down

  def handle_event("w"), do: :up
  def handle_event("a"), do: :left
  def handle_event("s"), do: :down
  def handle_event("d"), do: :right

  def handle_event(_), do: :none
end
