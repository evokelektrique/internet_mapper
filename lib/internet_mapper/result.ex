defmodule InternetMapper.Result do
  use Memento.Table,
    attributes: [:id, :timestamp, :ip, :dns, :hex_color],
    type: :set
end
