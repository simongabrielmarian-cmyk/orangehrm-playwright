# This is the Dockerfile that actually runs the Playwright tests. 
# It uses the official Playwright image which has all the necessary dependencies pre-installed. 

# docker build -t orangehrm-tests:latest . has the role of building the image that will be used to run the tests.
# docker run --rm orangehrm-tests:latest is the command to execute the tests in a container based on the built image.

FROM mcr.microsoft.com/playwright:v1.58.1-jammy

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
CMD ["npx", "playwright", "test"]