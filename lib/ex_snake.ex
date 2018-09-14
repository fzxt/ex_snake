defmodule ExSnake do
  use Supervisor

  def start_link do
    # start the gui process
    children = [
      worker(ExSnake.Grid, [])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
