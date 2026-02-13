FROM mcr.microsoft.com/playwright:v1.58.1-jammy

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./
RUN npm ci

# Copy the rest of the application code to the container
COPY . .

# Expose any necessary ports (if your tests require it, e.g., for a web server)
CMD ["npx", "playwright", "test"]