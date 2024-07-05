defmodule Dialyxir.Formatter.GithubVerbose do
  @moduledoc false

  @behaviour Dialyxir.Formatter

  @impl Dialyxir.Formatter
  def format({tag, {file, location}, {warning_name, arguments}}) do
    processed_path = get_path(file)
    dialyzer_warning = {tag, {processed_path, location}, {warning_name, arguments}}

    """
    #{Dialyxir.Formatter.Github.format(dialyzer_warning)}
    ::group::#{Dialyxir.Formatter.Dialyxir.format(dialyzer_warning)}
    ::endgroup::
    """
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
