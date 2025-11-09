# ---- Build Stage ----
FROM node:alpine AS build

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build

# ---- Production Stage ----
FROM nginx:alpine

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy build output to nginx html directory
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
# Expose port 80 (optional but recommended)
EXPOSE 80

# Start nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
