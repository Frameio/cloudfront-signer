defmodule CloudfrontSigner.Signature do
  @moduledoc """
  Manages policy signing
  """
  alias CloudfrontSigner.Policy

  @doc """
  Converts a `Policy.t` struct to a cloudfront signature for the given private key
  """
  @spec signature(Policy.t, tuple) :: binary
  def signature(%Policy{} = policy, private_key) do
    to_string(policy)
    |> :public_key.sign(:sha, private_key)
    |> Base.encode64()
    |> String.to_charlist()
    |> Enum.map(&replace/1)
    |> to_string()
  end

  @compile {:inline, replace: 1}
  defp replace(?+), do: ?-
  defp replace(?=), do: ?_
  defp replace(?/), do: ?~
  defp replace(c), do: c
end