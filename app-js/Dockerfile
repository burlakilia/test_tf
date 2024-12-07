FROM node:16-slim

WORKDIR /app
RUN npm install express cors
COPY ./index.js .

CMD [ "node", "index.js" ]