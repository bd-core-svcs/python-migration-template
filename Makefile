.PHONY: help build-backstage deploy-backstage clean-backstage backstage-logs backstage-status
.PHONY: build-template test-template validate-template
.PHONY: setup-local setup-production
.PHONY: clean-all

# Default target
help:
	@echo "🚀 Service LLM Template - Comprehensive DevOps Portal"
	@echo ""
	@echo "Available commands:"
	@echo ""
	@echo "🏗️  Backstage Management:"
	@echo "  setup-local           - Setup local development environment"
	@echo "  setup-production      - Setup production environment (EKS)"
	@echo "  build-backstage       - Build Backstage Docker image"
	@echo "  deploy-backstage      - Deploy Backstage to EKS"
	@echo "  backstage-status      - Check Backstage deployment status"
	@echo "  backstage-logs        - View Backstage logs"
	@echo "  clean-backstage       - Clean Backstage deployment"
	@echo ""
	@echo "📝 Template Management:"
	@echo "  validate-template     - Validate the LLM service template"
	@echo "  test-template         - Test template generation locally"
	@echo "  build-template        - Build template documentation"
	@echo ""
	@echo "🧹 Cleanup:"
	@echo "  clean-all            - Clean everything (use with caution)"
	@echo ""
	@echo "🌐 URLs:"
	@echo "  Local:      http://localhost:3000"
	@echo "  Production: https://llm-template.platform.duckutil.net"
	@echo ""

# Backstage Management
setup-local:
	@echo "Setting up local development environment..."
	@if [ ! -f backstage/.env ]; then \
		echo "Creating local environment file..."; \
		cp backstage/app-config.yaml backstage/app-config.local.yaml; \
		echo "Please configure backstage/.env with your GitHub credentials"; \
	fi
	@echo "To start locally:"
	@echo "1. cd backstage"
	@echo "2. yarn install"
	@echo "3. yarn dev"

setup-production:
	@echo "Setting up production environment..."
	@./deploy-backstage.sh

build-backstage:
	@echo "Building Backstage Docker image..."
	@cd backstage && docker build -t ghcr.io/bd-core-svcs/service-llm-template-backstage:latest .
	@echo "✅ Backstage image built successfully"

deploy-backstage:
	@echo "Deploying Backstage to EKS..."
	@./deploy-backstage.sh

backstage-status:
	@echo "Checking Backstage deployment status..."
	@kubectl get pods -n backstage -l app.kubernetes.io/name=backstage
	@kubectl get services -n backstage -l app.kubernetes.io/name=backstage
	@kubectl get ingress -n backstage
	@echo ""
	@echo "🌐 Access URL: https://llm-template.platform.duckutil.net"

backstage-logs:
	@echo "Viewing Backstage logs..."
	@kubectl logs -f deployment/backstage-llm-template -n backstage

clean-backstage:
	@echo "Cleaning Backstage deployment..."
	@helm uninstall backstage-llm-template -n backstage || true
	@kubectl delete namespace backstage || true
	@echo "✅ Backstage deployment cleaned"

# Template Management
validate-template:
	@echo "Validating LLM service template..."
	@if command -v yamllint >/dev/null 2>&1; then \
		yamllint template.yaml; \
		echo "✅ Template YAML is valid"; \
	else \
		echo "⚠️  yamllint not found. Install with: pip install yamllint"; \
	fi
	@echo "Checking template structure..."
	@if [ -f template.yaml ] && [ -d skeleton ]; then \
		echo "✅ Template structure is valid"; \
	else \
		echo "❌ Template structure is invalid"; \
		exit 1; \
	fi

test-template:
	@echo "Testing template generation..."
	@echo "This would typically involve:"
	@echo "1. Running Backstage scaffolder in test mode"
	@echo "2. Generating a test service"
	@echo "3. Validating the generated output"
	@echo "💡 For full testing, use the Backstage UI after deployment"

build-template:
	@echo "Building template documentation..."
	@if command -v tree >/dev/null 2>&1; then \
		echo "Template structure:"; \
		tree -I 'node_modules|.git' .; \
	else \
		echo "📁 Template files:"; \
		find . -type f -name "*.yaml" -o -name "*.yml" -o -name "*.md" | head -20; \
	fi

# Utility targets
install-deps:
	@echo "Installing dependencies..."
	@if command -v brew >/dev/null 2>&1; then \
		echo "Installing via Homebrew..."; \
		brew install kubectl helm awscli yamllint; \
	elif command -v apt-get >/dev/null 2>&1; then \
		echo "Installing via apt..."; \
		sudo apt-get update && sudo apt-get install -y kubectl helm awscli yamllint; \
	else \
		echo "Please install kubectl, helm, awscli, and yamllint manually"; \
	fi

# GitHub Container Registry login
ghcr-login:
	@echo "Logging into GitHub Container Registry..."
	@if [ -z "$(GITHUB_TOKEN)" ]; then \
		echo "❌ GITHUB_TOKEN environment variable is required"; \
		echo "export GITHUB_TOKEN=your_github_token"; \
		exit 1; \
	fi
	@echo "$(GITHUB_TOKEN)" | docker login ghcr.io -u "$(GITHUB_USERNAME)" --password-stdin
	@echo "✅ Logged into GHCR successfully"

# Push images
push-backstage:
	@echo "Pushing Backstage image to registry..."
	@docker push ghcr.io/bd-core-svcs/service-llm-template-backstage:latest
	@echo "✅ Backstage image pushed successfully"

# Development workflow
dev-workflow: validate-template build-backstage
	@echo "🔄 Development workflow complete"
	@echo "✅ Template validated"
	@echo "✅ Backstage image built"
	@echo "💡 Next: Run 'make deploy-backstage' to deploy to EKS"

# Production deployment workflow
prod-workflow: validate-template build-backstage push-backstage deploy-backstage
	@echo "🚀 Production deployment workflow complete"
	@echo "✅ Template validated"
	@echo "✅ Backstage image built and pushed"
	@echo "✅ Deployed to EKS"
	@echo "🌐 Access at: https://llm-template.platform.duckutil.net"

# Cleanup everything
clean-all:
	@echo "⚠️  This will remove EVERYTHING related to this project"
	@read -p "Are you sure? (yes/no): " confirm && [ "$$confirm" = "yes" ] || exit 1
	@echo "Cleaning Backstage deployment..."
	@make clean-backstage
	@echo "Cleaning local Docker images..."
	@docker rmi ghcr.io/bd-core-svcs/service-llm-template-backstage:latest || true
	@echo "🧹 Cleanup complete"

# Development helpers
watch-pods:
	@echo "Watching pod status..."
	@watch kubectl get pods -n backstage

tail-logs:
	@echo "Tailing all Backstage logs..."
	@kubectl logs -f -l app.kubernetes.io/name=backstage -n backstage --all-containers=true

port-forward:
	@echo "Setting up port forwarding to Backstage service..."
	@echo "Backstage will be available at http://localhost:7007"
	@kubectl port-forward service/backstage-llm-template 7007:7007 -n backstage

# Quick access URLs
urls:
	@echo "🌐 Service URLs:"
	@echo ""
	@echo "Production Backstage:  https://llm-template.platform.duckutil.net"
	@echo "Local Development:     http://localhost:3000"
	@echo "Port Forward:          http://localhost:7007"
	@echo ""
	@echo "📱 GitHub Repository:   https://github.com/bd-core-svcs/service-llm-template"
	@echo "📦 Container Registry:  https://ghcr.io/bd-core-svcs/service-llm-template-backstage"

# Status dashboard
status:
	@echo "📊 Service LLM Template Portal Status"
	@echo "=================================="
	@echo ""
	@echo "🏗️  Template:"
	@if [ -f template.yaml ]; then echo "  ✅ Template exists"; else echo "  ❌ Template missing"; fi
	@if [ -d skeleton ]; then echo "  ✅ Skeleton directory exists"; else echo "  ❌ Skeleton missing"; fi
	@echo ""
	@echo "🐳 Docker:"
	@if docker images | grep -q "service-llm-template-backstage"; then echo "  ✅ Backstage image built"; else echo "  ⏳ Image not built locally"; fi
	@echo ""
	@echo "☸️  Kubernetes:"
	@if kubectl get namespace backstage >/dev/null 2>&1; then \
		echo "  ✅ Backstage namespace exists"; \
		kubectl get pods -n backstage --no-headers 2>/dev/null | wc -l | xargs echo "     Pods:" || echo "     Pods: 0"; \
	else \
		echo "  ⏳ Not deployed to Kubernetes"; \
	fi
