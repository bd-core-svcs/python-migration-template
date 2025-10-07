.PHONY: help run stop build test health logs clean k8s-deploy k8s-status k8s-logs k8s-clean
{%- if values.enableManagementCLI %}
.PHONY: setup-cli list-models create-key list-keys delete-key
{%- endif %}

# Default target
help:
	@echo "Available commands:"
	@echo "  run          - Start the service with docker-compose"
	@echo "  stop         - Stop the service"
	@echo "  build        - Build the Docker image"
	@echo "  test         - Run tests"
	@echo "  health       - Check service health"
	@echo "  logs         - View service logs"
	@echo "  clean        - Clean up containers and volumes"
{%- if values.enableManagementCLI %}
	@echo "  setup-cli    - Setup management CLI"
	@echo "  list-models  - List available models"
	@echo "  create-key   - Create API key (USER_ID=user@example.com KEY_NAME=name)"
	@echo "  list-keys    - List all API keys"
	@echo "  delete-key   - Delete API key (KEY_ID=key-id)"
{%- endif %}
	@echo "  k8s-deploy   - Deploy to Kubernetes"
	@echo "  k8s-status   - Check Kubernetes deployment status"
	@echo "  k8s-logs     - View Kubernetes logs"
	@echo "  k8s-clean    - Clean Kubernetes deployment"

# Local development
run:
	docker-compose up -d
	@echo "Service starting at http://localhost:${{ values.port }}"
	@echo "Health check: make health"
	@echo "Logs: make logs"

stop:
	docker-compose down

build:
	docker-compose build

test:
	docker-compose exec ${{ values.name }} pytest

health:
	@echo "Checking service health..."
	@curl -f http://localhost:${{ values.port }}/health && echo "✅ Service is healthy" || echo "❌ Service is unhealthy"

logs:
	docker-compose logs -f ${{ values.name }}

clean:
	docker-compose down -v
	docker-compose rm -f
	docker system prune -f

{%- if values.enableManagementCLI %}
# Management CLI
setup-cli:
	@echo "Setting up management CLI..."
	uv pip install -e .

list-models:
	@echo "Available models:"
	@curl -s http://localhost:${{ values.port }}/v1/models | jq '.data[].id'

create-key:
	@if [ -z "$(USER_ID)" ] || [ -z "$(KEY_NAME)" ]; then \
		echo "Usage: make create-key USER_ID=user@example.com KEY_NAME=my-key"; \
		exit 1; \
	fi
	@echo "Creating API key for $(USER_ID)..."
	@curl -X POST "http://localhost:${{ values.port }}/key/generate" \
		-H "Content-Type: application/json" \
		-H "Authorization: Bearer ${LITELLM_MASTER_KEY}" \
		-d '{"user_id": "$(USER_ID)", "key_alias": "$(KEY_NAME)"}'

list-keys:
	@echo "Listing all API keys..."
	@curl -s "http://localhost:${{ values.port }}/key/info" \
		-H "Authorization: Bearer ${LITELLM_MASTER_KEY}" | jq '.'

delete-key:
	@if [ -z "$(KEY_ID)" ]; then \
		echo "Usage: make delete-key KEY_ID=key-id"; \
		exit 1; \
	fi
	@echo "Deleting API key $(KEY_ID)..."
	@curl -X POST "http://localhost:${{ values.port }}/key/delete" \
		-H "Content-Type: application/json" \
		-H "Authorization: Bearer ${LITELLM_MASTER_KEY}" \
		-d '{"keys": ["$(KEY_ID)"]}'
{%- endif %}

# Kubernetes deployment
k8s-deploy:
	@echo "Deploying to Kubernetes..."
	helm upgrade --install ${{ values.name }} ./helm/${{ values.name }} \
		--namespace ${{ values.namespace }} \
		--create-namespace \
		--wait

k8s-status:
	@echo "Checking Kubernetes deployment status..."
	kubectl get pods -n ${{ values.namespace }} -l app.kubernetes.io/name=${{ values.name }}
	kubectl get services -n ${{ values.namespace }} -l app.kubernetes.io/name=${{ values.name }}
	kubectl get ingress -n ${{ values.namespace }} -l app.kubernetes.io/name=${{ values.name }}

k8s-logs:
	kubectl logs -f deployment/${{ values.name }} -n ${{ values.namespace }}

k8s-clean:
	helm uninstall ${{ values.name }} -n ${{ values.namespace }} || true
	kubectl delete namespace ${{ values.namespace }} || true

# Environment setup
.env:
	@echo "Creating .env file from .env.example..."
	@cp .env.example .env
	@echo "Please edit .env with your configuration"

# Development
dev: .env
	@echo "Starting development environment..."
	docker-compose -f docker-compose.yaml -f docker-compose.dev.yaml up -d

# Production
prod:
	@echo "Starting production environment..."
	docker-compose -f docker-compose.yaml -f docker-compose.prod.yaml up -d
