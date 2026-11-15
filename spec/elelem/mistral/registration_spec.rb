# frozen_string_literal: true

RSpec.describe "the mistral provider" do
  around do |example|
    saved = ENV.to_h.slice("MISTRAL_API_KEY", "MISTRAL_BASE_URL", "MISTRAL_MODEL")
    example.run
  ensure
    %w[MISTRAL_API_KEY MISTRAL_BASE_URL MISTRAL_MODEL].each { |k| ENV.delete(k) }
    ENV.update(saved)
  end

  before do
    ENV["MISTRAL_API_KEY"] = "test-key"
    ENV["MISTRAL_MODEL"] = "env-model"
    ENV.delete("MISTRAL_BASE_URL")
  end

  def build(**) = Elelem::Config.build_provider("mistral", **)
  def uri(**) = build(**).instance_variable_get(:@uri).to_s
  def model(**) = build(**).instance_variable_get(:@model)

  it "registers provider mistral" do
    expect(Elelem::Config.names).to include("mistral")
    expect(build).to be_a(Elelem::OpenAI::Provider)
  end

  it "talks to Mistral by default" do
    expect(uri).to eq("https://api.mistral.ai/v1/chat/completions")
  end

  it "sends MISTRAL_API_KEY" do
    expect(build.instance_variable_get(:@api_key)).to eq("test-key")
  end

  it "names MISTRAL_API_KEY when the key is missing or empty" do
    ENV.delete("MISTRAL_API_KEY")
    expect { build }.to raise_error(KeyError, /MISTRAL_API_KEY/)

    ENV["MISTRAL_API_KEY"] = " "
    expect { build }.to raise_error(KeyError, /MISTRAL_API_KEY/)
  end

  it "names MISTRAL_MODEL when no model is set, and treats an empty one as unset" do
    ENV.delete("MISTRAL_MODEL")
    expect { build }.to raise_error(KeyError, /MISTRAL_MODEL/)

    ENV["MISTRAL_MODEL"] = ""
    expect { build }.to raise_error(KeyError, /MISTRAL_MODEL/)
  end

  it "takes the model from MISTRAL_MODEL" do
    expect(model).to eq("env-model")
  end

  it "prefers --model over MISTRAL_MODEL" do
    expect(model(model: "flag-model")).to eq("flag-model")
  end

  it "uses MISTRAL_BASE_URL, with or without a trailing slash, and treats an empty one as unset" do
    ENV["MISTRAL_BASE_URL"] = "http://127.0.0.1:8080/v1/"
    expect(uri).to eq("http://127.0.0.1:8080/v1/chat/completions")

    ENV["MISTRAL_BASE_URL"] = "http://127.0.0.1:8080/v1"
    expect(uri).to eq("http://127.0.0.1:8080/v1/chat/completions")

    ENV["MISTRAL_BASE_URL"] = ""
    expect(uri).to eq("https://api.mistral.ai/v1/chat/completions")
  end
end
