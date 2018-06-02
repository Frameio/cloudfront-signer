defmodule CloudfrontSigner do
  @moduledoc """
  Elixir implementation of cloudfront's signed url algorithm.  Basic usage is:

  ```
  CloudfrontSigner.Distribution.from_config(:scope, :key)
  |> CloudfrontSigner.sign("some/path", [arg: "val"], some_expiry)
  ```
  """
  alias CloudfrontSigner.{Distribution, Policy, Signature}

  @doc """
  Signs a url for the given `Distribution.t` struct constructed from the `path` and `query_params` provided.  `expiry`
  is in seconds.
  """
  @spec sign(Distribution.t, binary, list, integer) :: binary
  def sign(%Distribution{domain: domain, private_key: pk, key_pair_id: kpi}, path, query_params \\ [], expiry) do
    expiry    = Timex.now() |> Timex.shift(seconds: expiry) |> Timex.to_unix()
    base_url  = URI.merge(domain, path) |> to_string()
    url       = url(base_url, query_params)
    signature = signature(url, expiry, pk)
    aws_query = signature_params(expiry, signature, kpi)

    signed_url(url, query_params, aws_query)
  end

  defp url(base, []), do: base
  defp url(base, ""), do: base
  defp url(base, query_params), do: base <> "?" <> prepare_query_params(query_params)

  defp signed_url(base, [], aws_query), do: base <> "?" <> aws_query
  defp signed_url(base, "", aws_query), do: base <> "?" <> aws_query
  defp signed_url(base, _params, aws_query), do: base <> "&" <> aws_query

  defp prepare_query_params(query_params) when is_binary(query_params), do: query_params
  defp prepare_query_params(query_params) when is_list(query_params) or is_map(query_params) do
    URI.encode_query(query_params)
  end

  defp signature_params(expires, signature, key_pair_id) do
    "Expires=#{expires}&Signature=#{signature}&Key-Pair-Id=#{key_pair_id}"
  end

  def signature(url, expiry, private_key) do
    %Policy{resource: url, expiry: expiry}
    |> Signature.signature(private_key)
  end
end
