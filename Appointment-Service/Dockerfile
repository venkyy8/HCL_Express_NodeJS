# Use Node.js runtime image
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy all app files
COPY . .

# Expose the port your service uses
EXPOSE 3001

# Command to run your microservice
CMD ["node", "appointment-service.js"]