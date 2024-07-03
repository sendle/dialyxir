defmodule Dialyxir.Formatter.GithubVerbose do
  @moduledoc false

  @behaviour Dialyxir.Formatter

  @impl Dialyxir.Formatter
  def format(dialyzer_warning) do
    """
    #{Dialyxir.Formatter.Github.format(dialyzer_warning)}
    ::group::#{Dialyxir.Formatter.Dialyxir.format(dialyzer_warning)}
    ::endgroup::
    """
  end
end
