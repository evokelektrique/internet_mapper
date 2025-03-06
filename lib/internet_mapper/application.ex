defmodule InternetMapper.Application do
  use Application

  def start(_type, _args) do
    # Restart and start Memento
    Memento.stop

    # Create Memento schema on this node. If it already exists, log and continue.
    schema_nodes = [node()]
    case Memento.Schema.create(schema_nodes) do
      :ok ->
        IO.puts("✅ Memento schema created")
      {:error, {:already_exists, _}} ->
        IO.puts("✅ Memento schema already exists")
      error ->
        IO.puts("❌ Memento schema creation error: #{inspect(error)}")
    end

    Memento.start

    if InternetMapper.Result in :mnesia.system_info(:tables) do
      IO.puts("✅ Table `InternetMapper.Result` already exists")
    else
      Memento.Table.create!(InternetMapper.Result, disc_copies: schema_nodes)
      IO.puts("✅ Table `InternetMapper.Result` created successfully")
    end

    children = [
      {Task.Supervisor, name: InternetMapper.TaskSupervisor},
      InternetMapper.BatchLogger,
      {Finch, name: InternetMapper.Finch}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
