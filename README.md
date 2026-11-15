# elelem-mistral

A [Mistral](https://console.mistral.ai/api-keys) provider plugin for [elelem](https://elelem.sh).
It talks to Mistral's OpenAI-compatible Chat Completions API
through [elelem-openai](https://github.com/elelem-sh/openai).

## Install

```sh
gem install elelem-mistral
```

## Use

```sh
export MISTRAL_API_KEY=...
elelem -p mistral --model MODEL
```

* `MISTRAL_API_KEY` (required): get one at https://console.mistral.ai/api-keys
* `MISTRAL_MODEL`: the model, when `--model` is not given
* `MISTRAL_BASE_URL`: overrides `https://api.mistral.ai/v1`

There is no default model, since free model lists change often. With
no model set, elelem stops and names `MISTRAL_MODEL`. A variable that is
set but empty counts as unset.

Free tier limits are on Mistral's own page: https://docs.mistral.ai/deployment/ai-studio/tier

## Development

```sh
bin/setup
bin/test
bin/lint
```

## License

MIT. See LICENSE.txt.
