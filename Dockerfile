# Use the official Node.js image as the base image for building
FROM node:14 as builder

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the application files to the container
COPY . .

# Build the Angular application
RUN npm run build --prod

# Use the official Nginx image as the final image
FROM nginx:alpine

# Copy the built Angular app from the builder stage to the nginx image
#COPY --from=builder /usr/src/app/dist/ng-k8s-example /usr/share/nginx/html

# (Optional) Remove the default Nginx welcome page
#RUN rm -rf /usr/share/nginx/html/*


WORKDIR /usr/share/nginx/html

COPY dist/ng-k8s-example /usr/share/nginx/html

# Ensure nginx user has read access
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R o+r /usr/share/nginx/html

# Expose the default Nginx port
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
