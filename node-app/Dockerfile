FROM node:23-alpine3.21

WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY ./src ./src

RUN addgroup -S nodegroup && adduser -S nodeuser -G nodegroup
USER nodeuser

EXPOSE 3000

ENV NODE_ENV=production
ENV PORT=3000

CMD ["node", "src/index.js"]