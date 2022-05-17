#This is the recommended LTS version of Node.js. 
FROM node:16.15.0-alpine

#By default, the Docker Node image includes a non-root node user that can be used to avoid running application container as root.
#Creating the node_modules subdirectory in /home/node along with the app directory. 
#Creating these directories will ensure that they have the permissions we want, which will be important when we create local node modules in the container with npm install. 

RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app

WORKDIR /home/node/app

#Adding this COPY instruction before running npm install or copying the application code allows us to take advantage of Docker’s caching mechanism
COPY package*.json ./

USER node

RUN npm install

RUN npm ci --only=production

COPY --chown=node:node . .

EXPOSE 3000

CMD [ "npm", "start" ]