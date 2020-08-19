defmodule CloudfrontSigner.Policy do
  @moduledoc """
  Defines a cloudfront signature policy, and a string coercion method for it
  """
  defstruct [:resource, :expiry]

  import Jason.Helpers

  @type t :: %__MODULE__{}

  defimpl String.Chars, for: CloudfrontSigner.Policy do
    @doc """
    json encodes a policy
    """
    def to_string(%{resource: resource, expiry: expiry}) do
      Jason.encode!(
        json_map(
          Statement: [
            json_map(
              Resource: resource,
              Condition: json_map(DateLessThan: json_map("AWS:EpochTime": expiry))
            )
          ]
        )
      )
    end
  end
end
