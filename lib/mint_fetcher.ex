defmodule MintFetcher do
  @moduledoc """
  Performs a non-blocking HTTP GET request using Mint for a given IP.
  """

  def fetch(ip) when is_binary(ip) do
    # Connect to the IP on port 80
    case Mint.HTTP.connect(:http, ip, 80, []) do
      {:ok, conn} ->
        # Issue a GET request for "/"
        case Mint.HTTP.request(conn, "GET", "/", [], nil) do
          {:ok, conn, request_ref} ->
            loop_fetch(conn, request_ref)
          {:error, _conn, reason} ->
            {:failure, reason}
        end
      {:error, reason} ->
        {:failure, reason}
    end
  end

  defp loop_fetch(conn, request_ref) do
    receive do
      message ->
        case Mint.HTTP.stream(conn, message) do
          {:ok, conn, responses} ->
            if complete?(responses, request_ref) do
              code = extract_status_code(responses, request_ref)
              {:success, code}
            else
              loop_fetch(conn, request_ref)
            end
          {:error, _conn, reason, _responses} ->
            {:failure, reason}
        end
    after
      5000 ->
        {:failure, :timeout}
    end
  end

  defp complete?(responses, request_ref) do
    Enum.any?(responses, fn
      {:done, ref} when ref == request_ref -> true
      _ -> false
    end)
  end

  defp extract_status_code(responses, request_ref) do
    Enum.find_value(responses, fn
      {:status, ref, code} when ref == request_ref -> code
      _ -> nil
    end)
  end
end
