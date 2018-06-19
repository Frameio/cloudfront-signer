# CloudfrontSigner

Elixir implementation of Cloudfront's url signature algorithm.  Supports expiration policies and
runtime configurable distributions. 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `cloudfront_signer` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cloudfront_signer, "~> 0.1.0"}
  ]
end
```

Configure a distribution with:

```elixir
config :my_app, :my_distribution,
  domain: "https://some.cloudfront.domain",
  private_key: {:system, "ENV_VAR"}, # or {:file, "/path/to/key"}
  key_pair_id: {:system, "OTHER_ENV_VAR"}
```

Then simply do:
```elixir
CloudfrontSigner.Distribution.from_config(:my_app, :my_distribution)
|> CloudfrontSigner.sign(path, [arg: "value"], expiry_in_seconds)
```

If you want to cache pem decodes (which is a wise choice), a registry of decoded distributions is available.  Simply do:

```elixir
CloudfrontSigner.DistributionRegistry.get_distribution(:my_app, :my_distribution)
|> CloudfrontSigner.sign(path, [arg: "value], expiry)
```