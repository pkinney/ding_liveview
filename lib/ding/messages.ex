defmodule Ding.Messages do
  @topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(Ding.PubSub, @topic)
  end

  def send_message(body) do
    message = %{body: body, timestamp: DateTime.utc_now()}
    Phoenix.PubSub.broadcast!(Ding.PubSub, @topic, {__MODULE__, [:message, :received], message})
  end
end
