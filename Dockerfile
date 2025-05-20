# Use a newer version of Node.js (e.g., Node.js 16)
FROM node:16

# Create and set working directory
WORKDIR /app

# Copy package.json and package-lock.json (if exists)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files
COPY . .

# Expose the app on port 3000
EXPOSE 3000

# Command to run the app
CMD ["node", "app.js"]
