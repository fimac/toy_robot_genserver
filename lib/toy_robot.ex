defmodule ToyRobot do
  use GenServer
  # MOVE, LEFT, RIGHT
  def init(_args) do
    {:ok, {0, 0, "N"}}
  end

  def start_link(args \\ []) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def place(x, y, f) do
    GenServer.call(__MODULE__, {:place, x, y, f})
  end

  def move() do
    GenServer.call(__MODULE__, :move)
    report()
  end

  def left() do
    GenServer.call(__MODULE__, :left)
    report()
  end

  def right() do
    GenServer.call(__MODULE__, :right)
    report()
  end

  def report() do
    GenServer.call(__MODULE__, :report)
  end

  def handle_call({:place, x, y, f}, _from, {_x, _y, _f}) do
    {:reply, :ok, {x, y, f}}
  end

  def handle_call(:move, _from, {x, y, "N"}) when y < 4 do
    {:reply, :ok, {x, y + 1, "N"}}
  end

  def handle_call(:move, _from, {x, y, "E"}) when x < 4 do
    {:reply, :ok, {x + 1, y, "E"}}
  end

  def handle_call(:move, _from, {x, y, "S"}) when y > 0 do
    {:reply, :ok, {x, y - 1, "S"}}
  end

  def handle_call(:move, _from, {x, y, "W"}) when x > 0 do
    {:reply, :ok, {x - 1, y, "W"}}
  end

  def handle_call(:left, _from, {x, y, f}) when f in ["N", "E", "W", "S"] do
    case f do
      "N" -> {:reply, :ok, {x, y, "W"}}
      "E" -> {:reply, :ok, {x, y, "N"}}
      "S" -> {:reply, :ok, {x, y, "E"}}
      "W" -> {:reply, :ok, {x, y, "S"}}
    end
  end

  def handle_call(:right, _from, {x, y, f}) when f in ["N", "E", "W", "S"] do
    case f do
      "N" -> {:reply, :ok, {x, y, "E"}}
      "E" -> {:reply, :ok, {x, y, "S"}}
      "S" -> {:reply, :ok, {x, y, "W"}}
      "W" -> {:reply, :ok, {x, y, "N"}}
    end
  end

  def handle_call(:report, _from, state) do
    {:reply, state, state}
  end

  # this is here a catch all so the gen server doesn't crash.
  def handle_call(_, _from, state) do
    {:reply, :ok, state}
  end
end
