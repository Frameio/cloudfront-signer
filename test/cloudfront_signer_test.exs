defmodule CloudfrontSignerTest do
  use ExUnit.Case
  doctest CloudfrontSigner

  describe "#sign/3" do
    test "it will return something" do
      distribution = CloudfrontSigner.Distribution.from_config(:cloudfront_signer, CloudfrontSignerTest)
      signed_url = CloudfrontSigner.sign(distribution, "/bucket/key", [arg: "val"], 60 * 1000)

      assert signed_url =~ "Signature"
      assert signed_url =~ "Expires"
      assert signed_url =~ "Key-Pair-Id"
      assert signed_url =~ "/bucket/key?arg=val"
    end
  end
end
