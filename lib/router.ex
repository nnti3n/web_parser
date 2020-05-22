defmodule Play.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  require EEx
  EEx.function_from_file :defp, :template_count_char, "templates/count_char.eex", [:url, :count, :body]
  get "/:url" do
    response = HTTPoison.get!("https://#{url}")
    IO.puts String.length(response.body)

    map = response.body
    |> String.graphemes()
    |> Enum.reduce(%{}, fn char, acc ->
      if String.match?(char, ~r/[ -~]/) do
        Map.put(acc, char, (acc[char] || 0) + 1)
      else
        acc
      end
    end)

    count_result = map
    |> Map.keys()
    |> Enum.map(fn key -> "#{key}: #{map[key]}" end)
    |> Enum.join(", ")
    IO.puts count_result

    page_contents = template_count_char(url, count_result, response.body)
    conn |> put_resp_content_type("text/html") |> send_resp(200, page_contents)
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end
