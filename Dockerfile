FROM node:22-alpine AS build

WORKDIR /app

# Install dependencies (inclui devDependencies com @angular/cli)
COPY package*.json ./
RUN npm install

# Copy source and build using local ng binary
COPY . .
RUN ./node_modules/.bin/ng build --configuration production

# Production stage with Nginx
FROM nginx:alpine

# Copy build output (path: dist/servPim/browser)
COPY --from=build /app/dist/servPim/browser /usr/share/nginx/html

# Copy nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
