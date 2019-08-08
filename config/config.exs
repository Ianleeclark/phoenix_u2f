use Mix.Config

config :phoenix_u2f,
  # TODO(ian): Default to phoenix json encoder rather than explicit jason dependency (this will require change in u2f_ex)
  app_id: "https://yoursite.com",
  repo: nil
