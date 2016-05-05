defmodule Foo.TestWorker do
  require Logger
  use GenServer

  def start_link do
    Logger.debug "start"
    GenServer.start_link(__MODULE__, %{}, name: :worker)
  end

  def init(state) do
    Logger.debug "init"
    Process.send_after(self(), :work, 1)
    {:ok, state}
  end

  def handle_info(:work, state) do
    Logger.debug "handle info 0.0.1"
    Process.send_after(self(), :work, 5000)

    {:noreply, state}
  end
end
