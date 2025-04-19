# Stage 1: Build the React app
FROM node:18-alpine AS build

# Set working directory
WORKDIR /app

# Accept Firebase environment variables as build args
ARG REACT_APP_API_KEY
ARG REACT_APP_AUTH_DOMAIN
ARG REACT_APP_PROJECT_ID
ARG REACT_APP_STORAGE_BUCKET
ARG REACT_APP_MESSAGING_SENDER_ID
ARG REACT_APP_APP_ID

# Inject them into the environment so React can access them during build
ENV REACT_APP_API_KEY=$REACT_APP_API_KEY
ENV REACT_APP_AUTH_DOMAIN=$REACT_APP_AUTH_DOMAIN
ENV REACT_APP_PROJECT_ID=$REACT_APP_PROJECT_ID
ENV REACT_APP_STORAGE_BUCKET=$REACT_APP_STORAGE_BUCKET
ENV REACT_APP_MESSAGING_SENDER_ID=$REACT_APP_MESSAGING_SENDER_ID
ENV REACT_APP_APP_ID=$REACT_APP_APP_ID

# Copy and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy source and build
COPY . ./
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:stable-alpine as production

# Clean default nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy build output from previous stage
COPY --from=build /app/build /usr/share/nginx/html

# Optional: Add security headers or custom config
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
