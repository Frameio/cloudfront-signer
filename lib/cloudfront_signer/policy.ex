defmodule CloudfrontSigner.Policy do
  @moduledoc """
  Defines a cloudfront signature policy, and a string coercion method for it
  """
  defstruct [:resource, :expiry]

  @type t :: %__MODULE__{}

  defimpl String.Chars, for: CloudfrontSigner.Policy do
    @doc """
    json encodes a policy
    """
    def to_string(%{resource: resource, expiry: expiry}) do
      aws_policy(resource, expiry)
      |> Poison.encode!()
    end

    defp aws_policy(resource, expiry) do
      %{
        Statement: [
          %{
            Resource: resource, 
            Condition: %{
              DateLessThan: %{
                "AWS:EpochTime": expiry
              }
            }
          }
        ]
      }
    end
  end
end