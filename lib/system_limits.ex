defmodule SystemLimits do
  @moduledoc """
  Retrieves and logs system limits.
  """

  @doc """
  Gets the open file descriptor limit.
  """
  def get_open_file_limit do
    case System.cmd("bash", ["-c", "ulimit -n"]) do
      {result, 0} -> String.trim(result)
      {_, _} -> "unknown"
    end
  end

  @doc """
  Logs the open file descriptor limit.
  """
  def log_limits do
    limit = get_open_file_limit()
    IO.puts("Open file descriptor limit: #{limit}")
    limit
  end
end
