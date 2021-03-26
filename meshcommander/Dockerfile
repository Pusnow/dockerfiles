FROM node:buster

RUN mkdir /app; cd /app; npm install meshcommander

WORKDIR /app/node_modules
CMD ["node", "meshcommander", "--any"]