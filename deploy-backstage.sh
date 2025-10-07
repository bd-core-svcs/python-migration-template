#!/bin/bash

# Service LLM Template - Backstage Deployment Script
# This script deploys a complete Backstage instance to EKS for LLM service template management

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
NAMESPACE="backstage"
CLUSTER_NAME="sig-saas-innovation-zone"
AWS_REGION="us-east-1"
DOMAIN="platform.duckutil.net"
SUBDOMAIN="llm-template"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Prerequisites check
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    local missing_tools=()
    
    if ! command_exists kubectl; then
        missing_tools+=("kubectl")
    fi
    
    if ! command_exists helm; then
        missing_tools+=("helm")
    fi
    
    if ! command_exists aws; then
        missing_tools+=("aws")
    fi
    
    if ! command_exists docker; then
        missing_tools+=("docker")
    fi
    
    if [ ${#missing_tools[@]} -ne 0 ]; then
        print_error "Missing required tools: ${missing_tools[*]}"
        print_error "Please install the missing tools and try again."
        exit 1
    fi
    
    print_success "All prerequisites satisfied"
}

# Function to setup AWS credentials and kubectl
setup_aws() {
    print_status "Setting up AWS credentials and kubeconfig..."
    
    # Check if AWS credentials are configured
    if ! aws sts get-caller-identity >/dev/null 2>&1; then
        print_error "AWS credentials not configured. Please run 'aws configure' first."
        exit 1
    fi
    
    # Update kubeconfig for EKS cluster
    print_status "Updating kubeconfig for EKS cluster: $CLUSTER_NAME"
    aws eks update-kubeconfig --name "$CLUSTER_NAME" --region "$AWS_REGION"
    
    # Verify cluster connectivity
    if ! kubectl cluster-info >/dev/null 2>&1; then
        print_error "Cannot connect to Kubernetes cluster. Please check your AWS credentials and cluster configuration."
        exit 1
    fi
    
    print_success "AWS and Kubernetes connectivity verified"
}

# Function to build and push Docker image
build_and_push_image() {
    print_status "Building and pushing Backstage Docker image..."
    
    local image_tag="ghcr.io/bd-core-svcs/service-llm-template-backstage:latest"
    
    # Check if user is logged in to GHCR
    print_status "Checking GitHub Container Registry login..."
    if ! docker pull ghcr.io/bd-core-svcs/service-llm-template-backstage:latest >/dev/null 2>&1; then
        print_warning "Not logged in to GHCR or image doesn't exist. Building locally..."
        
        # Build the image
        print_status "Building Backstage image..."
        cd backstage
        docker build -t "$image_tag" .
        cd ..
        
        print_warning "Image built locally. To push to registry, login with:"
        print_warning "echo \$GITHUB_TOKEN | docker login ghcr.io -u \$GITHUB_USERNAME --password-stdin"
        print_warning "docker push $image_tag"
    else
        print_success "Using existing image from registry"
    fi
}

# Function to create namespace
create_namespace() {
    print_status "Creating namespace: $NAMESPACE"
    
    if kubectl get namespace "$NAMESPACE" >/dev/null 2>&1; then
        print_warning "Namespace $NAMESPACE already exists"
    else
        kubectl create namespace "$NAMESPACE"
        print_success "Namespace $NAMESPACE created"
    fi
}

# Function to setup secrets
setup_secrets() {
    print_status "Setting up secrets..."
    
    # Check if secrets exist
    if kubectl get secret backstage-llm-template-secrets -n "$NAMESPACE" >/dev/null 2>&1; then
        print_warning "Secrets already exist. Skipping secret creation."
        print_warning "To update secrets, delete the existing secret first:"
        print_warning "kubectl delete secret backstage-llm-template-secrets -n $NAMESPACE"
        return
    fi
    
    # Prompt for GitHub credentials
    echo ""
    print_status "GitHub integration setup required."
    print_status "You need a GitHub App or OAuth App for Backstage integration."
    echo ""
    
    read -p "GitHub Client ID: " github_client_id
    read -s -p "GitHub Client Secret: " github_client_secret
    echo ""
    read -s -p "GitHub Token (PAT): " github_token
    echo ""
    
    # Optional GitHub App credentials
    read -p "GitHub App ID (optional, press enter to skip): " github_app_id
    read -p "GitHub App Installation ID (optional): " github_app_installation_id
    
    if [ -n "$github_app_id" ]; then
        echo "GitHub App Private Key (paste the full key including headers, press Ctrl+D when done):"
        github_app_private_key=$(cat)
    else
        github_app_private_key=""
    fi
    
    # AWS configuration
    aws_account_id=$(aws sts get-caller-identity --query Account --output text)
    
    # Create secrets
    kubectl create secret generic backstage-llm-template-secrets \
        --from-literal=github-client-id="$github_client_id" \
        --from-literal=github-client-secret="$github_client_secret" \
        --from-literal=github-token="$github_token" \
        --from-literal=github-app-id="$github_app_id" \
        --from-literal=github-app-installation-id="$github_app_installation_id" \
        --from-literal=github-app-private-key="$github_app_private_key" \
        --namespace "$NAMESPACE"
    
    print_success "Secrets created successfully"
}

# Function to deploy with Helm
deploy_with_helm() {
    print_status "Deploying Backstage with Helm..."
    
    # Get AWS account ID
    aws_account_id=$(aws sts get-caller-identity --query Account --output text)
    
    # Deploy using Helm
    helm upgrade --install backstage-llm-template ./backstage/charts/backstage \
        --namespace "$NAMESPACE" \
        --create-namespace \
        --set config.aws.accountId="$aws_account_id" \
        --set config.aws.region="$AWS_REGION" \
        --set config.techdocs.s3BucketName="backstage-techdocs-$aws_account_id" \
        --set ingress.hosts[0].host="$SUBDOMAIN.$DOMAIN" \
        --set ingress.tls[0].hosts[0]="$SUBDOMAIN.$DOMAIN" \
        --set ingress.tls[0].secretName="backstage-tls" \
        --wait \
        --timeout 10m
    
    print_success "Backstage deployed successfully"
}

# Function to verify deployment
verify_deployment() {
    print_status "Verifying deployment..."
    
    # Check pods
    print_status "Checking pods..."
    kubectl get pods -n "$NAMESPACE" -l app.kubernetes.io/name=backstage
    
    # Check services
    print_status "Checking services..."
    kubectl get services -n "$NAMESPACE" -l app.kubernetes.io/name=backstage
    
    # Check ingress
    print_status "Checking ingress..."
    kubectl get ingress -n "$NAMESPACE"
    
    # Get service URL
    local service_url="https://$SUBDOMAIN.$DOMAIN"
    
    print_success "Deployment verification complete!"
    echo ""
    print_success "🎉 Backstage is deployed and should be available at: $service_url"
    echo ""
    print_status "Next steps:"
    echo "1. Wait for the ingress to provision the SSL certificate (may take a few minutes)"
    echo "2. Access Backstage at $service_url"
    echo "3. The LLM Service Template should be available in the template catalog"
    echo "4. Use the template to create new LLM services in the bd-core-svcs organization"
    echo ""
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help                Show this help message"
    echo "  -n, --namespace NAME      Kubernetes namespace (default: backstage)"
    echo "  -c, --cluster NAME        EKS cluster name (default: sig-saas-innovation-zone)"
    echo "  -r, --region REGION       AWS region (default: us-east-1)"
    echo "  -d, --domain DOMAIN       Base domain (default: platform.duckutil.net)"
    echo "  -s, --subdomain SUBDOMAIN Subdomain (default: llm-template)"
    echo ""
    echo "Environment variables:"
    echo "  AWS_PROFILE              AWS profile to use"
    echo "  GITHUB_TOKEN             GitHub token for container registry"
    echo ""
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_usage
            exit 0
            ;;
        -n|--namespace)
            NAMESPACE="$2"
            shift 2
            ;;
        -c|--cluster)
            CLUSTER_NAME="$2"
            shift 2
            ;;
        -r|--region)
            AWS_REGION="$2"
            shift 2
            ;;
        -d|--domain)
            DOMAIN="$2"
            shift 2
            ;;
        -s|--subdomain)
            SUBDOMAIN="$2"
            shift 2
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Main execution
main() {
    echo ""
    print_status "🚀 Starting Backstage deployment for LLM Service Template Portal"
    echo ""
    print_status "Configuration:"
    echo "  Namespace: $NAMESPACE"
    echo "  Cluster: $CLUSTER_NAME"
    echo "  Region: $AWS_REGION"
    echo "  URL: https://$SUBDOMAIN.$DOMAIN"
    echo ""
    
    check_prerequisites
    setup_aws
    build_and_push_image
    create_namespace
    setup_secrets
    deploy_with_helm
    verify_deployment
}

# Run main function
main "$@"
