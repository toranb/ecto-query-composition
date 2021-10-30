defmodule BulkWeb.PageController do
  use BulkWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
