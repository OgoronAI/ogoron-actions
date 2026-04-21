# Ogoron Actions

GitHub Actions for using Ogoron in customer repositories.

This repository is organized as a multi-action repo. Each public action lives in
its own subdirectory.

## Before you start

- Review the product terms: <https://ogoron.com/terms>
- Review the privacy policy: <https://ogoron.com/privacy>
- Get your Ogoron repository token in the product UI: <https://app.ogoron.ai/>
- Read the GitHub Actions guide: <https://docs.ogoron.ai/ci-cd/github-actions>

## Required secrets

The exact set depends on the workflow:

- `OGORON_REPO_TOKEN`  
  Repository-scoped Ogoron access token. Obtain it in <https://app.ogoron.ai/>.
- `OGORON_LLM_API_KEY`  
  Only needed when your Ogoron access mode requires BYOK.
- `GITHUB_TOKEN`  
  Only needed for workflows that create branches or pull requests.

## Actions

- [`setup/`](./setup)  
  Bootstrap or migrate Ogoron in a repository and deliver the result through a pull request.
- [`exec/`](./exec)  
  Install Ogoron and execute one or more explicit commands in a repository.
- [`generate/`](./generate)  
  Generate unit, API, and UI test artifacts on Linux runners.
- [`heal/`](./heal)  
  Run Ogoron heal workflows for generated or project tests on Linux runners.
- [`run/`](./run)  
  Run generated or project tests on Linux runners.

## Planned actions

- `feature/`

## Current scope

- Linux runners only
- Linux Ogoron release assets only
- GitHub Actions workflows and examples only

## Recommended path

1. Run `setup` once to bootstrap `.ogoron/` in the repository.
2. Use `generate` to create or refresh artifacts.
3. Use `run`-style workflows to execute tests.
4. Use `heal` to investigate and repair failing generated tests.
5. Use `exec` as a low-level escape hatch when you need explicit command control.

## Example

```yaml
name: Ogoron Setup

on:
  workflow_dispatch:

jobs:
  setup-ogoron:
    runs-on: ubuntu-latest
    permissions:
      contents: write
      pull-requests: write

    steps:
      - uses: actions/checkout@v4

      - name: Set up Ogoron
        uses: OgoronAI/ogoron-actions/setup@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          OGORON_REPO_TOKEN: ${{ secrets.OGORON_REPO_TOKEN }}
          OGORON_LLM_API_KEY: ${{ secrets.OGORON_LLM_API_KEY }}
```

See also:
- [`examples/setup.yml`](./examples/setup.yml)
- [`examples/run.yml`](./examples/run.yml)

## Documentation

- Docs home: <https://docs.ogoron.ai/>
- GitHub Actions guide: <https://docs.ogoron.ai/ci-cd/github-actions>
- CLI overview: <https://docs.ogoron.ai/cli/overview>
- Generate command: <https://docs.ogoron.ai/cli/generate>
- Heal command: <https://docs.ogoron.ai/cli/heal>
