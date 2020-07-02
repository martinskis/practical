FROM node:12

USER node
RUN git clone --depth 1 --branch master git://github.com/swimlane/devops-practical.git /home/node/app
WORKDIR /home/node/app
RUN npm install

EXPOSE 3000
CMD ["npm", "run", "prod"]
