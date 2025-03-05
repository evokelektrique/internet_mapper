defmodule IPMapperTest do
  use ExUnit.Case
  alias IPGenerator
  alias DNSLookup
  alias MintFetcher
  alias CSVLogger
  alias IPMapper

  @moduletag timeout: 15000

  test "IPGenerator generates incremental IPs" do
    ips = IPGenerator.generate_ips("1.0.0.0", 3)
    assert ips == ["1.0.0.0", "1.0.0.1", "1.0.0.2"]
  end

  test "DNSLookup returns a valid DNS for localhost" do
    # Many systems resolve 127.0.0.1 as "localhost"
    dns = DNSLookup.lookup("127.0.0.1")
    assert dns != nil
    # Note: Depending on your system configuration the result might vary.
  end

  test "MintFetcher returns success or failure" do
    # Using a known IP (example.com) that should respond.
    result = MintFetcher.fetch("93.184.216.34")
    assert match?({:success, _code}, result) or match?({:failure, _reason}, result)
  end

  test "CSVLogger writes to file" do
    # Remove any pre-existing CSV file.
    File.rm("results.csv")
    CSVLogger.init()
    CSVLogger.log_result("1.0.0.0", "localhost", {:success, 200}, "#00FF00")
    content = File.read!("results.csv")
    assert String.contains?(content, "1.0.0.0")
  end

  test "Pipeline processes IPs" do
    # Integration test: start a small pipeline and wait for processing.
    File.rm("results.csv")
    IPMapper.start("1.0.0.0", 5, 2)
    Process.sleep(6000)
    content = File.read!("results.csv")
    lines = String.split(content, "\n", trim: true)
    # Header plus 5 entries expected.
    assert length(lines) >= 6
  end
end
