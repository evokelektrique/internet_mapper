defmodule IPMapper do
  @moduledoc """
  Starts the IP mapping pipeline:
    - Logs system limits.
    - Generates incremental IP addresses from a given starting IP.
    - Processes them concurrently using GenStage and MintFetcher.
    - Performs a reverse DNS lookup for each IP.
    - Logs results (with timestamp, IP, DNS, HTTP status, and hex color) to a CSV file.
    - Tracks progress (ETA, completed, remaining) via console logging.
  """

  @doc """
  Starts the pipeline.

  Parameters:
    - `start_ip`: A string representing the starting IP (e.g., "1.0.0.0").
    - `public_ip_count`: Number of incremental IPs to generate.
    - `consumer_count`: Number of concurrent consumers (default: 100).

  The pipeline runs until all IP addresses are processed.
  """
  def start(start_ip, public_ip_count, consumer_count \\ 100) do
    # Log system limits.
    SystemLimits.log_limits()

    # Initialize the CSV file (write header if needed).
    CSVLogger.init()

    # Generate incremental IP addresses.
    ip_list = IPGenerator.generate_ips(start_ip, public_ip_count)

    # Start the progress logger with the total count.
    {:ok, _progress_logger} = ProgressLogger.start_link(length(ip_list))

    # Start the producer with the generated IP list.
    {:ok, _producer} = IPMapper.Producer.start_link(ip_list)

    # Start the specified number of consumers.
    for _ <- 1..consumer_count do
      {:ok, _consumer} = IPMapper.Consumer.start_link([])
    end

    :ok
  end
end
