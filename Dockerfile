FROM node:17-alpine
RUN mkdir -p /app
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build
EXPOSE 3004
CMD ["npm", "run", "start"]
