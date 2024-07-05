defmodule Dialyxir.Formatter.Github do
  @moduledoc false

  alias Dialyxir.Formatter.Utils

  @behaviour Dialyxir.Formatter

  @impl Dialyxir.Formatter
  def format({_tag, {file, location}, {warning_name, arguments}}) do
    base_name = get_path(file)

    warning = Utils.warning(warning_name)
    string = warning.format_short(arguments)

    case location do
      {line, col} ->
        "::warning file=#{base_name},startLine=#{line},startColumn=#{col},title=#{warning_name}::#{string}"

      line ->
        "::warning file=#{base_name},startLine=#{line},title=#{warning_name}::#{string}"
    end
  end

  defp get_path(file) do
    if File.exists?(file) do
      file
    else
      cwd = File.cwd!()
      case Path.wildcard("#{cwd}/**/#{file}") do
        [path] ->
          Path.relative_to_cwd(path)
        _ ->
          file
      end
    end
  rescue
    File.Error ->
      file
  end
end
