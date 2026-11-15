# frozen_string_literal: true

require "elelem/openai"

require_relative "mistral/version"

Elelem.configure do |config|
  config.provider(:mistral) do |model: nil, **|
    # A variable that is set but empty counts as unset.
    env = ->(name) { ENV[name].to_s.strip.then { |v| v.empty? ? nil : v } }
    key = env.call("MISTRAL_API_KEY")
    raise KeyError, "MISTRAL_API_KEY is not set" if key.nil?

    model = env.call("MISTRAL_MODEL") if model.to_s.strip.empty?
    raise KeyError, "MISTRAL_MODEL is not set. Pass --model or set MISTRAL_MODEL" if model.nil?

    Elelem::OpenAI::Provider.new(
      model:,
      api_key: key,
      base_url: env.call("MISTRAL_BASE_URL") || "https://api.mistral.ai/v1"
    )
  end
end
