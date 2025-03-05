# IPMapper

IPMapper is an Elixir-based tool that generates incremental IP addresses, performs non-blocking HTTP requests using Mint, and does reverse DNS lookups. It logs the results (including timestamp, IP, DNS name, HTTP status, and a hex color) to a CSV file while providing real-time progress updates.

## Features

- **Incremental IP Generation:** Start from a given IP and generate sequential IP addresses.
- **Non-blocking HTTP Requests:** Uses Mint to perform HTTP GET requests concurrently.
- **Reverse DNS Lookups:** Retrieves DNS names for IP addresses.
- **CSV Logging:** Logs results with timestamps and hex color codes.
- **Progress Tracking:** Displays processed count, remaining count, and ETA.
- **System Limits Logging:** Logs open file descriptor limits at startup.

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/evokelektrique/ip_mapper.git
   cd ip_mapper
   ```

2. Fetch dependencies:

   ```bash
   mix deps.get
   ```

3. Compile the project:

   ```bash
   mix compile
   ```

## Usage

Start an interactive shell with:

```bash
iex -S mix
```

Then run the pipeline (for example, to generate 100 sequential IPs starting at `1.0.0.0` with 50 consumers):

```elixir
IPMapper.start("1.0.0.0", 100, 50)
```

Progress will be printed to the console and results logged to `results.csv`.

## Running Tests

To run the test suite:

```bash
mix test
```

## License

This project is licensed under the MIT License.
