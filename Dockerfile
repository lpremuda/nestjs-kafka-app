# syntax = docker/dockerfile:1.4.3

ARG VERSION=18.18.2

#############################
# Build
#############################
FROM node:${VERSION} AS build
# RUN apt-get update && apt-get install -y --no-install-recommends dumb-init=1.2.5-1
WORKDIR /usr/src/app

# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package*.json ./
COPY prisma ./prisma/

RUN npm ci
COPY . .
# Creates a "dist" folder with the production build
RUN npm run build
# npm ci is run again here after the build to remove dev dependencies required for the build step
RUN npm ci --omit=dev && npm cache clean --force

#############################
# Production
#############################
FROM node:${VERSION}
ENV NODE_ENV production

USER node
WORKDIR /usr/src/app
COPY --chown=node:node --from=build /usr/src/app/node_modules ./node_modules
COPY --chown=node:node --from=build /usr/src/app/dist ./dist
COPY --chown=node:node --from=build /usr/src/app/package.json ./package.json
COPY --chown=node:node --from=build /usr/src/app/prisma/schema.prisma ./prisma/schema.prisma
COPY --chown=node:node --from=build /usr/src/app/prisma/migrations ./prisma/migrations

# Expose port 3000 (TCP). This doesn't actually publish the port on the container (done during docker run),
# but rather serves are documentation
EXPOSE 3000

# Start the server using the production build
# Calls 'node dist/main'
CMD ["sleep 100000"]
# CMD ["npm", "run", "start:prod"]
