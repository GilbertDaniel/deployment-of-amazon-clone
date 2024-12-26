# Stage 1: Build
FROM node:16 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json (or yarn.lock) to the container
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy the rest of the application code to the container
COPY . .

# Build the React app
RUN npm run build

# Stage 2: Production
FROM node:16-slim

# Set the working directory inside the container
WORKDIR /app

# Copy only the build folder from the previous stage
COPY --from=builder /app/build ./build

# Install a minimal web server for serving static files
RUN npm install -g serve

# Expose the port that the app will run on
EXPOSE 3000

# Start the static file server
CMD ["serve", "-s", "build"]
