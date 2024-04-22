# --Start of builder step--
# Use an existing Docker image as a base
FROM node:16-alpine as builder

# WSL fixes for docker x node
USER node
 
RUN mkdir -p /home/node/app
WORKDIR /home/node/app
 
COPY --chown=node:node ./package.json ./
RUN npm install
COPY --chown=node:node ./ ./
RUN npm run build
# --End of builder step--

# --Start of run step--
FROM nginx
COPY --from=builder /home/node/app/build /usr/share/nginx/html

# Tell the image what to do when it starts as a container
# nginx starts by default