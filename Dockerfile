# Dockerfile

# Use a specific Node.js base image
FROM node:22.19.0-alpine

# Set working directory
WORKDIR /usr/src/app

# Copy dependency definitions
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all your source code
COPY . .

# Expose port your app listens on; change if your app uses a different port
EXPOSE 3000

# Start your app
CMD ["node", "app.js"]
