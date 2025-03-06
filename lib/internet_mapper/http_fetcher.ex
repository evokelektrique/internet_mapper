defmodule InternetMapper.HTTPFetcher do
  def fetch(ip) when is_binary(ip) do
    url = "http://#{ip}/"
    req = Finch.build(:get, url)

    case Finch.request(req, InternetMapper.Finch, receive_timeout: 5_000) do
      {:ok, %Finch.Response{status: status}} -> {:success, status}
      {:error, reason} -> {:failure, reason}
    end
  rescue
    e -> {:failure, e}
  end
end
