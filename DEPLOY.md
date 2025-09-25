#!/bin/bash

# Quick Deployment Guide
# ======================
# This script provides a quick reference for deploying the infrastructure

echo "🚀 AWS Basic Website Deployment Guide"
echo "====================================="
echo ""

echo "📋 Prerequisites:"
echo "1. AWS CLI configured with proper credentials"
echo "2. Terraform installed (>= 1.5.0)"
echo "3. Appropriate AWS permissions"
echo ""

echo "🔧 Quick Deployment Steps:"
echo ""
echo "1. Initialize Terraform:"
echo "   terraform init"
echo ""

echo "2. Review and customize variables (optional):"
echo "   vim terraform.tfvars"
echo ""

echo "3. Plan deployment:"
echo "   terraform plan"
echo ""

echo "4. Deploy infrastructure:"
echo "   terraform apply"
echo ""

echo "5. Check website status:"
echo "   ./check-website.sh"
echo ""

echo "6. Get website URL:"
echo "   terraform output load_balancer_url"
echo ""

echo "💡 Using Makefile (alternative):"
echo "   make deploy    # Full deployment workflow"
echo "   make output    # Show outputs"
echo "   make destroy   # Cleanup everything"
echo ""

echo "🔍 Monitoring:"
echo "   - Website URL will be shown in terraform output"
echo "   - Check AWS Console for detailed resource status"
echo "   - Use ./check-website.sh for automated health checks"
echo ""

echo "🧹 Cleanup:"
echo "   terraform destroy"
echo ""

echo "📚 For detailed instructions, see README.md"