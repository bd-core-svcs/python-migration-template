# Python Service Migration Template# Python Service Migration Template



A Backstage template for migrating Python services from one GitHub organization to another, specifically designed for LLM services, FastAPI applications, and other Python-based services.A Backstage template for migrating Python services from one GitHub organization to another, specifically designed for LLM services, FastAPI applications, and other Python-based services.



## 🎯 Purpose## � Purpose



This template facilitates cross-organization repository migration for Python services, particularly from `SIG-Innovation-Zone` to `bd-polaris` organization, while preserving:This template facilitates cross-organization repository migration for Python services, particularly from `SIG-Innovation-Zone` to `bd-polaris` organization, while preserving:



- ✅ Complete source code and git history- ✅ Complete source code and git history

- ✅ Python-specific CI/CD workflows  - ✅ Python-specific CI/CD workflows  

- ✅ Database and Redis configurations- ✅ Database and Redis configurations

- ✅ Documentation and dependencies- ✅ Documentation and dependencies

- ✅ Backstage catalog integration- ✅ Backstage catalog integration

- ✅ ArgoCD deployment configurations- ✅ ArgoCD deployment configurations



## 🐍 Python Service Support## � Python Service Support



### Supported Service Types### Supported Service Types

- **LLM Gateway** (LiteLLM-based services)- **LLM Gateway** (LiteLLM-based services)

- **FastAPI** applications- **FastAPI** applications

- **Flask** applications  - **Flask** applications  

- **Django** applications- **Django** applications

- **ML/AI Services**- **ML/AI Services**

- **Data Services**- **Data Services**

- **Web Services**- **Web Services**



### Supported Python Versions### Supported Python Versions

- Python 3.9- Python 3.9

- Python 3.10- Python 3.10

- Python 3.11 (default)- Python 3.11 (default)

- Python 3.12- Python 3.12



### Framework Support### Framework Support

- **FastAPI** (default)- **FastAPI** (default)

- **Flask**- **Flask**

- **Django**- **Django**

- **LiteLLM**- **LiteLLM**

- **Custom frameworks**- **Custom frameworks**



## 📋 Template Features## 📋 Template Features



### Migration Capabilities### Migration Capabilities

1. **Source Repository Fetch** - Pulls complete source code from origin1. **Source Repository Fetch** - Pulls complete source code from origin

2. **Python Template Overlay** - Applies Python-specific configurations2. **Python Template Overlay** - Applies Python-specific configurations

3. **GitHub Workflow Generation** - Creates Python CI/CD pipeline3. **GitHub Workflow Generation** - Creates Python CI/CD pipeline

4. **ArgoCD Configuration** - Generates deployment configurations4. **ArgoCD Configuration** - Generates deployment configurations

5. **Backstage Registration** - Registers service in catalog5. **Backstage Registration** - Registers service in catalog



### Generated Files### Generated Files

``````

migrated-repository/migrated-repository/

├── .github/workflows/├── .github/workflows/

│   └── build-deploy.yml          # Python CI/CD workflow│   └── build-deploy.yml          # Python CI/CD workflow

├── catalog-info.yaml             # Updated Backstage metadata├── catalog-info.yaml             # Updated Backstage metadata

├── argocd-config/                # ArgoCD deployment config├── argocd-config/                # ArgoCD deployment config

│   ├── appset.yaml│   ├── appset.yaml

│   └── dev-values.yaml│   └── dev-values.yaml

└── [original source files...]    # All original source code└── [original source files...]    # All original source code

```│   ├── Dockerfile                   # Service container

│   ├── litellm-config.yaml         # LLM provider configuration

## 🚀 Usage│   ├── Makefile                     # Development workflows

│   └── ...                         # Complete service skeleton

### 1. Access the Template├── 🚀 deploy-backstage.sh           # Automated EKS deployment script

Navigate to your Backstage instance: https://backstage.platform.duckutil.net/create├── 📋 Makefile                      # Comprehensive workflows

├── 📖 template.yaml                 # Backstage template definition

### 2. Select Python Migration Template└── 📚 README.md                     # This file

Look for **"Python Service Migration (Cross-Organization)"**```



### 3. Fill Template Parameters## 🚀 Quick Start



#### **Source & Destination**### Prerequisites

- **Source Repository**: `https://github.com/SIG-Innovation-Zone/service-llm`

- **Destination Owner**: `bd-polaris` (or other target org)- **AWS CLI** configured with EKS permissions

- **Destination Repository**: `service-llm` (or desired name)- **kubectl** configured for your EKS cluster

- **Helm 3.x** installed

#### **Python Configuration**- **Docker** for building images

- **Python Version**: Select from 3.9, 3.10, 3.11, 3.12- **GitHub** account and organization access (`bd-core-svcs`)

- **Framework**: FastAPI, Flask, Django, LiteLLM, etc.

- **Service Type**: LLM Gateway, API Service, ML Service, etc.### 1. Deploy Backstage to EKS



#### **Features**```bash

- ✅ **Update Dockerfile**: Modify for new organization# Clone this repository

- ✅ **Add Python GitHub Workflow**: Python-specific CI/CDgit clone https://github.com/bd-core-svcs/service-llm-template.git

- ✅ **Create ArgoCD Configuration**: Deployment automationcd service-llm-template

- ✅ **Has Database**: PostgreSQL/MySQL support

- ✅ **Has Redis**: Redis caching support# Deploy to EKS (interactive setup)

- ✅ **Has Documentation**: MkDocs/Sphinx support./deploy-backstage.sh



### 4. Execute Migration# Or use the Makefile

The template will:make setup-production

1. Fetch source code from origin repository```

2. Apply Python-specific overlay configurations

3. Create new repository in destination organizationThe deployment script will:

4. Generate CI/CD workflow with Python best practices- ✅ Verify prerequisites (kubectl, helm, aws cli)

5. Create ArgoCD configuration for deployment- ✅ Build and push Backstage Docker image

6. Register service in Backstage catalog- ✅ Create Kubernetes namespace and secrets

- ✅ Deploy with Helm to EKS cluster

## 🔧 Generated CI/CD Pipeline- ✅ Configure ingress with SSL termination



The Python workflow includes:### 2. Access Your Portal



### **Lint and Test Stage**After deployment, access your Backstage portal at:

- **Python Setup** (specified version)**https://llm-template.platform.duckutil.net**

- **Dependency Caching** (pip cache optimization)

- **Code Linting** (flake8, black formatting)### 3. Create LLM Services

- **Type Checking** (mypy)

- **Unit Testing** (pytest)1. Navigate to **"Create"** → **"Choose a template"**

2. Select **"LLM Gateway Service"**

### **Container Build Stage**3. Configure your service:

- **Docker Build** with Python optimizations   - **Name**: `my-llm-gateway`

- **Google Artifact Registry** push   - **Description**: "My LLM Gateway Service"

- **Version Tagging** with date prefixes   - **URL**: `my-llm`

   - **Domain**: `duckutil.net`

### **Deployment Stage**   - Enable optional features (PostgreSQL, Redis, Auth)

- **BD Polaris Environment** deployment4. Click **"Create"** → New repository created in `bd-core-svcs` org

- **Health Check Verification**

- **Notification System**## 🏗️ Architecture



## 🏗️ ArgoCD Configuration### Backstage Portal Components



Generated ArgoCD setup includes:```mermaid

graph TB

### **ApplicationSet**    subgraph "EKS Cluster"

- **Multi-environment** support (dev/staging/prod)        subgraph "backstage namespace"

- **Automated sync** with self-healing            BS[Backstage Pod]

- **Namespace creation**            PG[PostgreSQL]

- **Helm value overrides**            BS --> PG

        end

### **Helm Values**        

- **Python runtime** configuration        subgraph "Ingress"

- **Database connections** (PostgreSQL)            IG[NGINX Ingress]

- **Redis caching** setup            IG --> BS

- **Ingress/TLS** configuration        end

- **Resource limits** and autoscaling    end

- **Health checks** and probes    

    subgraph "External"

## 📁 Template Structure        DNS[llm-template.platform.duckutil.net]

        GH[GitHub bd-core-svcs]

```        DNS --> IG

python-migration-template/        BS --> GH

├── python-migration-template.yaml  # Main template definition    end

├── migration-skeleton/             # Python-specific overlays```

│   ├── catalog-info.yaml          # Backstage metadata

│   └── .github/workflows/### Generated LLM Service Architecture

│       └── build-deploy.yml       # Python CI/CD

├── argocd-config/                  # Deployment configurations```mermaid

│   ├── appset.yaml                # ArgoCD ApplicationSetgraph TB

│   └── dev-values.yaml            # Helm values    subgraph "Generated Service"

└── README.md                       # This documentation        LLM[LiteLLM Gateway]

```        subgraph "Optional Components"

            PG[PostgreSQL]

## 🔗 Integration            RD[Redis]

            AUTH[Auth0]

### **GitHub Apps Required**        end

- **bd-migration-reader**: Source repository access (SIG-Innovation-Zone)        LLM --> PG

- **bd-migration-reader**: Destination repository creation (bd-polaris)        LLM --> RD

        LLM --> AUTH

### **Installation IDs**    end

- **SIG-Innovation-Zone**: 87335202    

- **bd-polaris**: 87452237    subgraph "LLM Providers"

        AZURE[Azure OpenAI]

### **Permissions Required**        AWS[AWS Bedrock]

- **Contents**: Read/Write        OAI[OpenAI]

- **Administration**: Write (for repository creation)    end

- **Pull Requests**: Write    

- **Metadata**: Read    LLM --> AZURE

    LLM --> AWS

## 🎯 Example Migration    LLM --> OAI

    

### **Source**    subgraph "Client Applications"

`https://github.com/SIG-Innovation-Zone/service-llm`        APP[Your Apps]

- LLM Gateway service built with LiteLLM        APP --> LLM

- Python 3.11, FastAPI framework    end

- PostgreSQL + Redis dependencies```

- Existing CI/CD in Innovation Zone

## 📝 Template Features

### **Result** 

`https://github.com/bd-polaris/service-llm`The LLM Service Template generates:

- ✅ Complete source code migrated

- ✅ Updated for bd-polaris organization### Core Features

- ✅ Python 3.11 CI/CD workflow- ✅ **OpenAI-compatible API** for multiple LLM providers

- ✅ BD Polaris deployment pipeline- ✅ **Docker containerization** with health checks

- ✅ ArgoCD configuration ready- ✅ **Kubernetes deployment** via Helm charts

- ✅ Backstage catalog registration- ✅ **GitHub Actions CI/CD** pipeline

- ✅ **Ingress configuration** with TLS termination

## 🔍 Troubleshooting

### Configurable Components

### **Common Issues**- 🔄 **PostgreSQL** - Audit logging and data persistence

1. **GitHub App Permissions**: Ensure Administration (Write) permission- 🔄 **Redis** - Response caching and rate limiting  

2. **Installation IDs**: Verify correct IDs for source/destination orgs- 🔄 **Auth0/OAuth** - Authentication and authorization

3. **Python Dependencies**: Check requirements.txt compatibility- 🔄 **Management CLI** - User and API key administration

4. **Database Connections**: Update connection strings for new environment

### Supported LLM Providers

### **Support**- **Azure OpenAI** - GPT-4o, GPT-4o-mini, GPT-3.5-turbo

- Check logs in Backstage scaffolder- **AWS Bedrock** - Claude 3.5 Sonnet, Claude 3 Haiku

- Verify GitHub App installations- **OpenAI Direct** - All OpenAI models

- Review template parameters- **Extensible** - Easy to add more providers

- Contact platform team for assistance

## 🛠️ Development Workflows

## 📊 Success Metrics

### Using the Makefile

Post-migration verification:

- ✅ Repository created in destination organization```bash

- ✅ CI/CD pipeline executing successfully# View all available commands

- ✅ ArgoCD application syncingmake help

- ✅ Service discoverable in Backstage catalog

- ✅ Health checks passing# Development workflow

- ✅ Database/Redis connections workingmake dev-workflow          # Validate template + build image



---# Production deployment

make prod-workflow          # Full deployment pipeline

**Template Version**: 1.0  

**Last Updated**: October 2025  # Monitoring and debugging

**Maintainer**: Platform Team  make backstage-status       # Check deployment status

**Support**: Python Service Migrationmake backstage-logs         # View logs
make port-forward           # Access via localhost

# Template management
make validate-template      # Validate template syntax
make test-template          # Test template generation
```

### Local Development

```bash
# Setup local Backstage development
make setup-local
cd backstage
yarn install
yarn dev

# Access at http://localhost:3000
```

## 🔧 Configuration

### Environment Variables

Set these in your CI/CD environment:

```bash
# GitHub Integration
GITHUB_TOKEN=ghp_xxxxxxxxxxxx
GITHUB_CLIENT_ID=Iv1.xxxxxxxxxxxx  
GITHUB_CLIENT_SECRET=xxxxxxxxxxxx

# GitHub App (optional, for enhanced features)
GITHUB_APP_ID=123456
GITHUB_APP_INSTALLATION_ID=12345678
GITHUB_APP_PRIVATE_KEY="-----BEGIN RSA PRIVATE KEY-----..."

# AWS Configuration
AWS_ACCESS_KEY_ID=AKIAXXXXXXXXXXXXXXXX
AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
AWS_ACCOUNT_ID=123456789012

# TechDocs (optional)
TECHDOCS_S3_BUCKET_NAME=backstage-techdocs-123456789012
```

### Template Parameters

When creating services, configure:

#### Required
- `name` - Service name (kebab-case)
- `description` - Service description  
- `url` - Subdomain for the service
- `domain` - Your domain (e.g., `duckutil.net`)
- `owner` - Owner email/username

#### Optional  
- `port` - Service port (default: 4000)
- `namespace` - K8s namespace (default: labs)
- `litellmVersion` - LiteLLM version (default: 1.34.0)
- `enablePostgreSQL` - Database integration
- `enableRedis` - Caching layer
- `enableAuth` - Authentication system
- `enableManagementCLI` - Admin CLI tools

## 🚢 Deployment Options

### 1. Production EKS Deployment

```bash
# Automated deployment
./deploy-backstage.sh

# Manual Helm deployment  
helm upgrade --install backstage-llm-template ./backstage/charts/backstage \
  --namespace backstage \
  --create-namespace \
  --set config.github.clientId="$GITHUB_CLIENT_ID" \
  --set config.github.clientSecret="$GITHUB_CLIENT_SECRET" \
  --wait
```

### 2. Local Development

```bash
cd backstage
yarn install
yarn dev
# Access at http://localhost:3000
```

### 3. Container Deployment

```bash
# Build image
make build-backstage

# Run container
docker run -p 7007:7007 \
  -e GITHUB_TOKEN="$GITHUB_TOKEN" \
  ghcr.io/bd-core-svcs/service-llm-template-backstage:latest
```

## 🔍 Monitoring & Operations

### Health Checks

```bash
# Check all components
make status

# Kubernetes status
make backstage-status

# View logs
make backstage-logs

# Port forwarding for debugging
make port-forward
```

### URLs and Access

```bash
# Show all URLs
make urls

# Production:  https://llm-template.platform.duckutil.net
# Local:       http://localhost:3000  
# Debug:       http://localhost:7007
```

## 🔐 Security

### GitHub Integration
- Uses GitHub Apps for enhanced security
- OAuth integration for user authentication
- Repository creation in `bd-core-svcs` organization

### Kubernetes Security
- Non-root container execution
- Resource limits and requests
- Network policies (configurable)
- Secret management via K8s secrets

### LLM Service Security
- API key management via Secrets
- Optional OAuth/Auth0 integration
- Rate limiting and usage tracking
- Audit logging (with PostgreSQL)

## 🤝 Contributing

1. **Fork** this repository
2. **Create** a feature branch
3. **Make** changes to templates or Backstage config
4. **Test** locally with `make dev-workflow`
5. **Submit** a pull request

### Template Development

```bash
# Validate your changes
make validate-template

# Test template generation
make test-template

# Build documentation
make build-template
```

## 📚 Documentation

### Service Template Documentation
- [Template Configuration](./template.yaml)
- [Skeleton Structure](./skeleton/)
- [Helm Charts](./skeleton/helm/)

### Backstage Documentation  
- [Application Config](./backstage/app-config.yaml)
- [Production Config](./backstage/app-config.production.yaml)
- [Deployment Charts](./backstage/charts/)

### Operational Guides
- [Deployment Guide](./deploy-backstage.sh)
- [Development Workflows](./Makefile)

## 🆘 Troubleshooting

### Common Issues

**1. Backstage not starting**
```bash
# Check pod status
kubectl get pods -n backstage
kubectl describe pod <pod-name> -n backstage

# Check logs
make backstage-logs
```

**2. Template not appearing**
```bash
# Verify template registration
kubectl exec -it deployment/backstage-llm-template -n backstage -- \
  curl localhost:7007/api/catalog/entities?filter=kind=template
```

**3. GitHub integration issues**
```bash
# Verify secrets
kubectl get secrets backstage-llm-template-secrets -n backstage -o yaml

# Test GitHub connectivity
kubectl exec -it deployment/backstage-llm-template -n backstage -- \
  curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user
```

### Support

- 📧 **Issues**: [GitHub Issues](https://github.com/bd-core-svcs/service-llm-template/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/bd-core-svcs/service-llm-template/discussions)
- 📖 **Documentation**: This README and inline docs

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🎯 Next Steps After Deployment

1. **Access your portal** at https://llm-template.platform.duckutil.net
2. **Create your first LLM service** using the template
3. **Configure LLM providers** (Azure OpenAI, AWS Bedrock, etc.)
4. **Set up monitoring** and observability
5. **Customize templates** for your specific needs

**🎉 You now have a complete, independent LLM service creation platform!**
