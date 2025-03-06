defmodule InternetMapper.DNSLookup do
  # Direct DNS lookup without caching
  def lookup(ip) when is_binary(ip) do
    case :inet.gethostbyaddr(String.to_charlist(ip)) do
      {:ok, {:hostent, hostname, _aliases, _addrtype, _length, _addresses}} ->
        to_string(hostname)

      {:error, _} ->
        "N/A"
    end
  end
end
