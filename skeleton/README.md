# ${{ values.name }}

${{ values.description }}

url: [${{ values.url }}.${{ values.domain }}](https://${{ values.url }}.${{ values.domain }})

[![Build and deploy to SIG SaaS Innovation Zone](https://github.com/bd-core-svcs/${{ values.name }}/actions/workflows/build-IZ.yml/badge.svg)](https://github.com/bd-core-svcs/${{ values.name }}/actions/workflows/build-IZ.yml)

## Overview

This is an LLM Gateway service built on [LiteLLM](https://litellm.vercel.app/) that provides:

- **OpenAI-compatible API** for multiple LLM providers
- **Authentication & Authorization** using Auth0/OAuth
{%- if values.enableRedis %}
- **Caching** with Redis for improved performance
{%- endif %}
{%- if values.enablePostgreSQL %}
- **Audit Logging** with PostgreSQL database
{%- endif %}
{%- if values.enableManagementCLI %}
- **Management CLI** for user and key administration
{%- endif %}
- **Kubernetes deployment** with Helm charts
- **Monitoring & Observability** with health checks and metrics

## Quick Start

### Prerequisites

- Docker and Docker Compose
- Python 3.8+ (for local development)
{%- if values.enableManagementCLI %}
- uv (for management CLI)
{%- endif %}

### Local Development

1. **Clone the repository:**
   ```bash
   git clone https://github.com/bd-core-svcs/${{ values.name }}.git
   cd ${{ values.name }}
   ```

2. **Set up environment variables:**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

3. **Start the service:**
   ```bash
   make run
   ```

4. **Check health:**
   ```bash
   make health
   ```

The service will be available at `http://localhost:${{ values.port }}`

### API Usage

Use the service as a drop-in replacement for OpenAI's API:

```python
import openai

client = openai.OpenAI(
    api_key="YOUR_API_KEY",
    base_url="https://${{ values.url }}.${{ values.domain }}"
)

response = client.chat.completions.create(
    model="gpt-4o",
    messages=[
        {"role": "user", "content": "Hello, world!"}
    ]
)
```

{%- if values.enableManagementCLI %}
### Management CLI

Use the management CLI for administrative tasks:

```bash
# List available models
make list-models

# Create an API key
make create-key USER_ID=user@blackduck.com KEY_NAME=my-key

# List all keys
make list-keys
```
{%- endif %}

### Web Interface

Access the management UI at: `https://${{ values.url }}.${{ values.domain }}/ui`

## Deployment

### Kubernetes with Helm

1. **Deploy to Kubernetes:**
   ```bash
   make k8s-deploy
   ```

2. **Check deployment status:**
   ```bash
   make k8s-status
   ```

3. **View logs:**
   ```bash
   make k8s-logs
   ```

## Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Client Apps   │───▶│  LLM Gateway    │───▶│  LLM Providers  │
│                 │    │  (${{ values.name }})    │    │  (Azure, AWS,   │
│                 │    │                 │    │   OpenAI, etc.) │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │
                                ▼
                       ┌─────────────────┐
                       │   Supporting    │
                       │   Services      │
{%- if values.enablePostgreSQL %}
                       │   - PostgreSQL  │
{%- endif %}
{%- if values.enableRedis %}
                       │   - Redis       │
{%- endif %}
{%- if values.enableAuth %}
                       │   - Auth0       │
{%- endif %}
                       └─────────────────┘
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License.
