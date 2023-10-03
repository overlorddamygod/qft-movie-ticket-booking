# Double-container Dockerfile for separated build process.
# If you're just copy-pasting this, don't forget a .dockerignore!

# We're starting with the same base image, but we're declaring
# that this block outputs an image called DEPS that we
# won't be deploying - it just installs our Yarn deps
FROM node:20.1.0 AS deps

# If you need libc for any of your deps, uncomment this line:
# RUN apk add --no-cache libc6-compat

# Copy over ONLY the package.json and yarn.lock
# so that this `yarn install` layer is only recomputed
# if these dependency files change. Nice speed hack!
WORKDIR /app
COPY package.json yarn.lock ./
# RUN yarn add --dev node-gyp

RUN yarn install --frozen-lockfile --ignore-scripts --prefer-offline

# END DEPS IMAGE

# Now we make a container to handle our Build
FROM node:lts AS BUILD_IMAGE

# Set up our work directory again
WORKDIR /app

# Bring over the deps we installed and now also
# the rest of the source code to build the Next
# server for production
COPY --from=deps /app/node_modules ./node_modules
COPY . .

ARG SUPABASE_URL
ARG SUPABASE_ANON_KEY
ARG STORAGE_URL
ARG STRIPE_PUBLIC_KEY
ARG SERVER_URL
ARG SSR_SERVER_URL
ARG GO_AUTH_SERVER_URL

ENV NEXT_PUBLIC_SUPABASE_URL=$SUPABASE_URL
ENV NEXT_PUBLIC_SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
ENV NEXT_PUBLIC_STORAGE_URL=$STORAGE_URL
ENV NEXT_PUBLIC_STRIPE_PUBLIC_KEY=$STRIPE_PUBLIC_KEY
ENV NEXT_PUBLIC_SERVER_URL=$SERVER_URL
ENV NEXT_PUBLIC_SSR_SERVER_URL=$SSR_SERVER_URL
ENV NEXT_PUBLIC_GO_AUTH_SERVER_URL=$GO_AUTH_SERVER_URL

RUN yarn build

# Remove all the development dependencies since we don't
# need them to run the actual server.
RUN rm -rf node_modules
RUN yarn install --production --frozen-lockfile --ignore-scripts --prefer-offline

# END OF BUILD_IMAGE

# This starts our application's run image - the final output of build.
FROM node:lts-alpine

ENV NODE_ENV production

RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

# Pull the built files out of BUILD_IMAGE - we need:
# 1. the package.json and yarn.lock
# 2. the Next build output and static files
# 3. the node_modules.
WORKDIR /app
COPY --from=BUILD_IMAGE --chown=nextjs:nodejs /app/package.json /app/yarn.lock ./
COPY --from=BUILD_IMAGE --chown=nextjs:nodejs /app/node_modules ./node_modules
COPY --from=BUILD_IMAGE --chown=nextjs:nodejs /app/public ./public
COPY --from=BUILD_IMAGE --chown=nextjs:nodejs /app/.next ./.next

# 4. OPTIONALLY the next.config.js, if your app has one
# COPY --from=BUILD_IMAGE --chown=nextjs:nodejs /app/next.config.js  ./
USER nextjs

EXPOSE 3000

CMD [ "yarn", "start" ]
