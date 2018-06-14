defmodule HelloWorld do
  @moduledoc """
  An Elli handler module written in Elixir.
  """

  @behaviour :elli_handler

  # Elli handler callbacks

  @impl :elli_handler
  def handle(req, _args) do
    # Delegate to our handler function
    handle(:elli_request.method(req), :elli_request.path(req), req)
  end

  # Return 200 to GET requests to /hello/world
  defp handle(:GET, ["hello", "world"], _req) do
    {200, [], "Hello, World!"}
  end

  # Return 200 and the first 20 chars of this file to GET requests to /send
  defp handle(:GET, ["send"], _req) do
    {:ok, [], { :file, __ENV__.file, [{:bytes, 0, 20}] } }
  end

  # Return 200 and a chunked stream to GET requests to /chunked
  defp handle(:GET, ["chunked"], req) do
    ref = :elli_request.chunk_ref(req)
    spawn_link fn -> chunk_loop(ref) end
    {:chunk, [{"Content-Type", "text/event-stream"}]}
  end

  # Return 404 to any other requests
  defp handle(_, _, _req) do
    {404, [], "Our princess is in another castle..."}
  end

  # start the chunk_loop with count n = 10...
  defp chunk_loop ref do
    chunk_loop ref, 10
  end
  # close the request when n = 0 is reached...
  defp chunk_loop ref, 0 do
    :elli_request.close_chunk ref
  end
  # count down the counter n... once a second.
  defp chunk_loop ref, n do
    :timer.sleep(1000)
    :elli_request.send_chunk(ref, ["chunk#{n}\n"])
    chunk_loop ref, n-1
  end

  # Handle request events, like request completed, exception
  # thrown, client timeout, etc. Must return `ok'.
  @impl :elli_handler
  def handle_event(_event, _data, _args) do
    :ok
  end

  # Web server process creation functions

  @doc """
  Specification used to start the web server in a supervision tree.
  """
  def child_spec(args) do
    %{
      id: __MODULE__,
      start: {HelloWorld, :start_link, [args]}
    }
  end

  @doc """
  Start and link a new Elli web server using this handler.
  """
  def start_link(args) do
    :elli.start_link(
      port: args[:port],
      callback: __MODULE__,
      callback_args: args
    )
  end
end
