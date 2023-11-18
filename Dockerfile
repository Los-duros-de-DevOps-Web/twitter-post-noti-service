# Etapa 1: Instalación de dependencias
FROM node:lts as dependencies
WORKDIR /twitter-post-noti
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Etapa 2: Reconstrucción del código fuente
FROM node:lts as builder
WORKDIR /twitter-post-noti
COPY . .
COPY --from=dependencies /twitter-post-noti/node_modules ./node_modules
RUN yarn build

# Generación de Prisma
RUN npx prisma generate

# Etapa 3: Imagen de Producción
FROM node:lts as runner
WORKDIR /twitter-post-noti
ENV NODE_ENV production

# Copia del archivo next.config.js (personalizado)
COPY --from=builder /twitter-post-noti/next.config.js ./

# Copia de otros archivos necesarios
COPY --from=builder /twitter-post-noti/public ./public
COPY --from=builder /twitter-post-noti/.next ./.next
COPY --from=builder /twitter-post-noti/node_modules ./node_modules
COPY --from=builder /twitter-post-noti/package.json ./package.json

EXPOSE 3004
CMD ["yarn", "start"]

