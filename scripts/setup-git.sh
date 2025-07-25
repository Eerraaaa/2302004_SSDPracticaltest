#!/bin/bash

# Git Server Setup Script
echo "🔧 Setting up Git server and repositories..."

# Set Git configuration
git config --global user.name "Loke-Yin-Er"
git config --global user.email "2302004@sit.singaporetech.edu.sg"
git config --global init.defaultBranch main

echo "✅ Git configuration set:"
echo "   Username: $(git config --global user.name)"
echo "   Email: $(git config --global user.email)"

# Create repositories directory if it doesn't exist
mkdir -p /git-repos

# Initialize the main repository
cd /git-repos

if [ ! -d "2302004_SSDPracticaltest" ]; then
    echo "📁 Creating main repository..."
    mkdir 2302004_SSDPracticaltest
    cd 2302004_SSDPracticaltest
    
    # Initialize Git repository
    git init
    
    # Create initial README
    cat > README.md << EOF
# SIT SSD Practical Test Repository

This is the local Git server repository for Singapore Institute of Technology (SIT) SSD Practical Test.

## Repository Information
- **Student ID**: 2302004
- **Git Username**: Loke-Yin-Er
- **Email**: 2302004@sit.singaporetech.edu.sg
- **Repository**: 2302004_SSDPracticaltest

## Docker Services
This repository includes:
- Nginx Web Server (Port 80)
- Gitea Git Server (Port 3000)
- Authentication system

## Access Points
- Web Server: http://localhost/
- Git Server: http://localhost:3000/
- Git SSH: ssh://git@localhost:222/

## Setup Commands
\`\`\`bash
# Clone this repository
git clone http://localhost:3000/Loke-Yin-Er/2302004_SSDPracticaltest.git

# Configure Git locally
git config user.name "Loke-Yin-Er"
git config user.email "2302004@sit.singaporetech.edu.sg"
\`\`\`

---
Created: $(date)
EOF
    
    # Add and commit initial files
    git add README.md
    git commit -m "Initial commit: SIT SSD Practical Test setup

- Added repository documentation
- Configured Git identity (Loke-Yin-Er / 2302004@sit.singaporetech.edu.sg)
- Set up Docker-based Git server infrastructure"
    
    echo "✅ Repository '2302004_SSDPracticaltest' created and initialized"
else
    echo "ℹ️  Repository already exists"
fi

# Create a bare repository for server use
if [ ! -d "2302004_SSDPracticaltest.git" ]; then
    echo "📦 Creating bare repository for Git server..."
    git clone --bare 2302004_SSDPracticaltest 2302004_SSDPracticaltest.git
    echo "✅ Bare repository created"
fi

echo "🎉 Git server setup completed!"
echo ""
echo "📋 Repository Information:"
echo "   Name: 2302004_SSDPracticaltest"
echo "   Owner: Loke-Yin-Er"
echo "   Email: 2302004@sit.singaporetech.edu.sg"
echo "   Location: /git-repos/"
echo ""
echo "🌐 Access URLs:"
echo "   Git Server UI: http://localhost:3000/"
echo "   Repository Clone: http://localhost:3000/Loke-Yin-Er/2302004_SSDPracticaltest.git"