# Stage 1: Build the React app
FROM node:18-alpine AS build

# Set working directory
WORKDIR /app

# Copy and install dependencies
COPY package.json ./
COPY package-lock.json ./
RUN npm install

# Copy the rest of the app and build
COPY . ./
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:stable-alpine as production

# Clean default nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy build output from previous stage
COPY --from=build /app/build /usr/share/nginx/html

# Optional: Custom nginx config (uncomment if you have one)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
