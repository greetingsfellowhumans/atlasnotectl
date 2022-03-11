defmodule AtlasWeb.Presence do
  use Phoenix.Presence,
    otp_app: :atlas,
    pubsub_server: Atlas.PubSub
end
