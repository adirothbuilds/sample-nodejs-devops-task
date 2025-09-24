# Use official Node.js image for the build stage
FROM node:22.1.0-slim AS builder

WORKDIR /app

# Copy package files and install production dependencies
COPY package*.json ./
RUN if [ -f "package-lock.json" ]; then \
    npm ci --omit=dev --ignore-scripts; \
    else \
    npm install --omit=dev --ignore-scripts; \
    fi

# Copy application source code - using .dockerignore to filter irrelevant files
COPY . .

# Apply restrictive permissions here
RUN chmod -R 555 /app

# Use distroless image for production
FROM gcr.io/distroless/nodejs22:nonroot

WORKDIR /app

# Copy built app from the builder stage
COPY --from=builder --chown=nonroot:nonroot /app ./

# Set environment variables
ENV NODE_ENV=production \
    PORT=8080

# Expose application port
EXPOSE 8080

# Run the container as a non-root user for improved security
USER nonroot

# Start the application
CMD ["app.js"]
