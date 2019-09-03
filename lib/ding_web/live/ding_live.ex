defmodule DingWeb.DingLive do
  use Phoenix.LiveView

  alias Ding.Messages
  alias DingWeb.DingView

  def mount(_session, socket) do
    if connected?(socket), do: Messages.subscribe()
    {:ok, fetch(socket)}
  end

  def render(assigns), do: DingView.render("index.html", assigns)

  def fetch(socket) do
    # TODO: eventually pull this from ETS or Mnesia
    assign(socket, messages: [])
  end

  def handle_info({Messages, [:message, :received], new_message}, socket) do
    {:noreply, assign(socket, messages: socket.assigns[:messages] ++ [new_message])}
  end

  def handle_event("send_message", %{"message" => %{"body" => body}}, socket) do
    Messages.send_message(body)
    {:noreply, socket}
  end
end
