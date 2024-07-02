defmodule Dialyxir.Formatter.GithubLong do
  @moduledoc false

  alias Dialyxir.Formatter.Utils

  @behaviour Dialyxir.Formatter

  @impl Dialyxir.Formatter
  def format(dialyzer_warning = {_tag, {file, location}, {warning_name, arguments}}) do
    base_name = Path.relative_to_cwd(file)

    warning = Utils.warning(warning_name)
    string = warning.format_short(arguments)
    long_title = "#{base_name}:#{Utils.format_location(location)}:#{warning_name}"
    long_text = Dialyxir.Formatter.Dialyxir.format(dialyzer_warning)

    case location do
      {line, col} ->
        """
        ::warning file=#{base_name},startLine=#{line},startColumn=#{col},title=#{warning_name}::#{string}
        ::group::#{long_title}
        #{long_text}
        ::endgroup::
        """

      line ->
        """
        ::warning file=#{base_name},startLine=#{line},title=#{warning_name}::#{string}
        ::group::#{long_title}
        #{long_text}
        ::endgroup::
        """
    end
  end
end
