defmodule CloudfrontSigner.Distribution do
  @moduledoc """
  Representation of a cloudfront distribution for the purpose of computing a signed url.
  We need the address of the distribution and the private key for RSA signature generation
  """
  defstruct [:private_key, :domain, :key_pair_id]

  @type t :: %__MODULE__{}
  
  @doc """
  Creates a `Distribution.t` record from the contents of `Application.get_env(app, scope)`
  """
  @spec from_config(atom, atom) :: t
  def from_config(app, scope) do
    Application.get_env(app, scope)
    |> Enum.map(&parse_config/1)
    |> Enum.filter(& &1)
    |> Enum.into(%{})
    |> from_map()
  end

  @spec from_map(map) :: t
  def from_map(map), do: struct(__MODULE__, map) |> decode_pk()

  defp parse_config({:domain, value}), do: {:domain, read_value(value)}
  defp parse_config({:private_key, value}), do: {:private_key, read_value(value)}
  defp parse_config({:key_pair_id, value}), do: {:key_pair_id, read_value(value)}
  defp parse_config(_), do: nil

  defp read_value({:system, env_var}), do: System.get_env(env_var)
  defp read_value({:file, file_path}), do: File.read!(file_path)
  defp read_value(value) when is_binary(value), do: value

  defp decode_pk(%__MODULE__{private_key: pk} = dist) when is_binary(pk) do
    String.trim(pk)
    |> :public_key.pem_decode()
    |> case do
      [pem_entry] -> %{dist | private_key: :public_key.pem_entry_decode(pem_entry)}
      _ -> raise ArgumentError, "Invalid PEM for cloudfront private key"
    end
  end
  defp decode_pk(dist), do: dist
end