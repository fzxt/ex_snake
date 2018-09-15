defmodule ExSnake do
  use Supervisor

  def start(_type, _args) do
    start_link()
  end

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    # start the gui process
    children = [
      worker(ExSnake.Grid, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end

defmodule ExSnake.CLI do
  def main(_args) do
    :erlang.hibernate(Kernel, :exit, [:killed])
  end
end
