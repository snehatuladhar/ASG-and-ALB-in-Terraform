#!/bin/bash
# Update the system
sudo apt-get update -y

# Install Node.js
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Nginx
sudo apt-get install -y nginx

# Configure Nginx
sudo mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
cat << 'EOF' | sudo tee /etc/nginx/sites-available/default
server {
    listen 80;

    server_name your_domain_or_IP;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
EOF

# Start Nginx
sudo systemctl restart nginx

# Clone your application repository
 git clone https://github.com/sandeshlama7/LAMP-EmployeeApp.gi

# Navigate to the application directory
cd /home/ubuntu/app

# Install dependencies
npm install

# Start the application
npm start
