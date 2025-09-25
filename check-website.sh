#!/bin/bash

# Website Status Checker Script
# This script checks if the website is accessible and healthy

set -e

echo "🔍 Website Status Checker"
echo "========================="

# Get the load balancer URL from Terraform output
echo "📡 Getting load balancer URL..."
LB_URL=$(terraform output -raw load_balancer_url 2>/dev/null || echo "")

if [ -z "$LB_URL" ]; then
    echo "❌ Could not get load balancer URL. Make sure Terraform is deployed."
    echo "   Run: terraform apply"
    exit 1
fi

echo "🌐 Website URL: $LB_URL"
echo ""

# Function to check HTTP response
check_website() {
    local url=$1
    local max_attempts=30
    local attempt=1
    
    echo "🚀 Checking website availability..."
    
    while [ $attempt -le $max_attempts ]; do
        echo -n "   Attempt $attempt/$max_attempts: "
        
        if response=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 10 --max-time 15 "$url" 2>/dev/null); then
            if [ "$response" = "200" ]; then
                echo "✅ Success (HTTP $response)"
                return 0
            else
                echo "⚠️  HTTP $response"
            fi
        else
            echo "❌ Connection failed"
        fi
        
        if [ $attempt -lt $max_attempts ]; then
            echo "      Waiting 10 seconds before next attempt..."
            sleep 10
        fi
        
        ((attempt++))
    done
    
    return 1
}

# Function to get website content preview
get_website_info() {
    local url=$1
    
    echo ""
    echo "📄 Website Content Preview:"
    echo "============================"
    
    # Get the title from the HTML
    if title=$(curl -s "$url" | grep -o '<title>[^<]*</title>' | sed 's/<[^>]*>//g' 2>/dev/null); then
        echo "🏷️  Title: $title"
    fi
    
    # Check response headers
    echo ""
    echo "📋 Response Headers:"
    echo "===================="
    curl -s -I "$url" | head -10
    
    # Check if load balancer is distributing traffic
    echo ""
    echo "🔄 Load Balancer Distribution Test:"
    echo "=================================="
    
    for i in {1..5}; do
        instance_info=$(curl -s "$url" | grep -o 'Instance ID:[^<]*' | sed 's/Instance ID: //' || echo "Unknown")
        echo "   Request $i: Instance $instance_info"
        sleep 1
    done
}

# Function to check Auto Scaling Group
check_asg() {
    echo ""
    echo "⚖️  Auto Scaling Group Status:"
    echo "=============================="
    
    if command -v aws >/dev/null 2>&1; then
        asg_name=$(terraform output -raw autoscaling_group_name 2>/dev/null || echo "")
        if [ -n "$asg_name" ]; then
            aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names "$asg_name" \
                --query 'AutoScalingGroups[0].{DesiredCapacity:DesiredCapacity,MinSize:MinSize,MaxSize:MaxSize,HealthyInstances:Instances[?LifecycleState==`InService`] | length(@)}' \
                --output table 2>/dev/null || echo "   Could not retrieve ASG information"
        else
            echo "   Could not get ASG name from Terraform outputs"
        fi
    else
        echo "   AWS CLI not available. Install AWS CLI for detailed ASG information."
    fi
}

# Function to show cost estimate
show_cost_info() {
    echo ""
    echo "💰 Estimated Monthly Cost:"
    echo "========================="
    echo "   • 2 × t3.micro instances: ~$15"
    echo "   • Application Load Balancer: ~$18"
    echo "   • 2 × NAT Gateways: ~$64"
    echo "   • Data transfer: Variable"
    echo "   • Total: ~$97/month"
    echo ""
    echo "💡 Cost optimization tips:"
    echo "   • Use t3.nano for lower costs"
    echo "   • Consider single NAT Gateway for dev"
    echo "   • Use Reserved Instances for production"
}

# Main execution
if check_website "$LB_URL"; then
    echo ""
    echo "🎉 Website is successfully deployed and accessible!"
    get_website_info "$LB_URL"
    check_asg
    show_cost_info
    echo ""
    echo "✨ Your website is ready!"
    echo "   Visit: $LB_URL"
else
    echo ""
    echo "❌ Website is not accessible yet."
    echo ""
    echo "🔧 Troubleshooting steps:"
    echo "   1. Check if deployment is complete: terraform output"
    echo "   2. Wait a few more minutes (instances may still be starting)"
    echo "   3. Check AWS Console for any issues"
    echo "   4. Verify security group rules"
    echo ""
    echo "⏱️  It typically takes 5-10 minutes for instances to become healthy"
    echo "   after initial deployment."
    exit 1
fi