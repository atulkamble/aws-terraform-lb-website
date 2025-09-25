#!/bin/bash

# Update the system
yum update -y

# Install Apache web server
yum install -y httpd

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Create a simple HTML page
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to ${project_name}</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .container {
            text-align: center;
            background: rgba(255, 255, 255, 0.1);
            padding: 2rem;
            border-radius: 10px;
            backdrop-filter: blur(10px);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        h1 {
            font-size: 3rem;
            margin-bottom: 1rem;
        }
        p {
            font-size: 1.2rem;
            margin-bottom: 1rem;
        }
        .info {
            background: rgba(255, 255, 255, 0.1);
            padding: 1rem;
            border-radius: 5px;
            margin-top: 2rem;
        }
        .status {
            color: #00ff88;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Welcome to ${project_name}!</h1>
        <p>Your website is successfully deployed on AWS with Terraform!</p>
        <div class="info">
            <p><strong>Server:</strong> $(hostname)</p>
            <p><strong>Instance ID:</strong> $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>
            <p><strong>Availability Zone:</strong> $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>
            <p class="status">✅ Load Balancer is working correctly!</p>
        </div>
        <p><em>Powered by AWS, Terraform, and Apache</em></p>
    </div>
</body>
</html>
EOF

# Create a health check endpoint
cat <<EOF > /var/www/html/health.html
<!DOCTYPE html>
<html>
<head>
    <title>Health Check</title>
</head>
<body>
    <h1>OK</h1>
    <p>Server is healthy</p>
</body>
</html>
EOF

# Set proper permissions
chown -R apache:apache /var/www/html
chmod -R 644 /var/www/html

# Restart Apache to ensure all changes are applied
systemctl restart httpd

# Log the completion
echo "Web server setup completed successfully" >> /var/log/user-data.log