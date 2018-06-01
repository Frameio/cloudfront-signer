defmodule CloudfrontSigner.Policy do
  @moduledoc """
  Defines a cloudfront signature policy, and a string coercion method for it
  """
  defstruct [:resource, :expiry]

  @type t :: %__MODULE__{}

  @doc """
  Converts a `Policy.t` to a json-encoded binary
  """
  @spec to_string(t) :: binary
  def to_string(%__MODULE__{resource: resource, expiry: expiry}) do
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