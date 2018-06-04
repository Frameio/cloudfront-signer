defmodule CloudfrontSigner.DistributionRegistryTest do
  use ExUnit.Case, async: true

  describe "#get_distribution/2" do
    test "It will get a registry and save it internally" do
      distribution = CloudfrontSigner.DistributionRegistry.get_distribution(:cloudfront_signer, CloudfrontSignerTest)

      assert distribution.domain == "https://somewhere.cloudfront.com"
    end
  end
end