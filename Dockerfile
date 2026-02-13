FROM mcr.microsoft.com/playwright:v1.58.1-jammy

# Switch to root to install git
USER root

# Install git
RUN apt-get update && \
    apt-get install -y git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy dependency files
COPY package*.json ./

# Install project dependencies
RUN npm ci

# Copy project files
COPY . .

# Optional: switch back to non-root (recommended for security)
USER pwuser

# Run Playwright tests
CMD ["npx", "playwright", "test"]
