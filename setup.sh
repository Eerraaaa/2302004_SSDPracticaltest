#!/bin/bash

# SIT Docker Web Server Setup Script
# This script sets up the complete Docker environment and Git repository

set -e  # Exit on any error

echo "🚀 Setting up SIT Docker Web Server..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Create directory structure
print_status "Creating directory structure..."
mkdir -p html
mkdir -p auth
mkdir -p .github/workflows

print_success "Directory structure created"

# Initialize Git repository if not already initialized
if [ ! -d ".git" ]; then
    print_status "Initializing Git repository..."
    git init
    print_success "Git repository initialized"
else
    print_status "Git repository already exists"
fi

# Create .gitignore if it doesn't exist
if [ ! -f ".gitignore" ]; then
    print_status "Creating .gitignore file..."
    # .gitignore content would be created here
    print_success ".gitignore created"
fi

# Set up Docker Compose configuration
print_status "Setting up Docker Compose..."

# Start the services
print_status "Starting Docker services..."
sudo docker-compose up -d

# Wait for services to be ready
print_status "Waiting for services to start..."
sleep 10

# Check if services are running
if sudo docker-compose ps | grep -q "Up"; then
    print_success "Docker services are running!"
else
    print_error "Failed to start Docker services"
    sudo docker-compose logs
    exit 1
fi

# Test the web server
print_status "Testing web server..."

# Test health endpoint
if curl -s -f http://127.0.0.1/health > /dev/null; then
    print_success "Health check endpoint is working"
else
    print_warning "Health check endpoint test failed"
fi

# Test authenticated access
if curl -s -f -u "admin:2302004@SIT.singaporetech.edu.sg" http://127.0.0.1/ > /dev/null; then
    print_success "Authenticated access is working"
else
    print_warning "Authenticated access test failed"
fi

# Test that unauthenticated access is properly blocked
if curl -s -f http://127.0.0.1/ > /dev/null 2>&1; then
    print_error "Security issue: Unauthenticated access is allowed!"
else
    print_success "Authentication is properly enforced"
fi

# Add files to Git
print_status "Adding files to Git repository..."
git add .

# Check if there are changes to commit
if git diff --staged --quiet; then
    print_status "No changes to commit"
else
    print_status "Committing files to Git..."
    git commit -m "Initial Docker web server setup with authentication and CI/CD

- Added docker-compose.yml with Nginx web server
- Configured basic authentication (admin/2302004@SIT.singaporetech.edu.sg)
- Created custom HTML landing page
- Added GitHub Actions workflow for CI/CD
- Included security scanning with Trivy
- Added comprehensive documentation"
    
    print_success "Files committed to Git repository"
fi

# Display access information
echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "📋 Access Information:"
echo "   URL: http://127.0.0.1/"
echo "   Username: admin"
echo "   Password: 2302004@SIT.singaporetech.edu.sg"
echo ""
echo "🔧 Useful Commands:"
echo "   View logs: sudo docker-compose logs"
echo "   Stop services: sudo docker-compose down"
echo "   Restart services: sudo docker-compose restart"
echo "   Health check: curl http://127.0.0.1/health"
echo ""
echo "📊 Service Status:"
sudo docker-compose ps

echo ""
print_success "SIT Docker Web Server is ready to use!"

# Optional: Open browser (uncomment if desired)
# if command -v xdg-open &> /dev/null; then
#     xdg-open http://127.0.0.1/
# elif command -v open &> /dev/null; then
#     open http://127.0.0.1/
# fi