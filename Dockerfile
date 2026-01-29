FROM ruby:3.3.6

# Install nodejs and npm
RUN apt-get update -qq && apt-get install -y \
    nodejs \
    npm \
    sqlite3 \
    build-essential \
    gosu

# Install Yarn
RUN npm install -g yarn

# Create and set working directory
WORKDIR /app

# Copy package.json and yarn.lock first to leverage Docker caching
COPY package.json yarn.lock ./

# Install JS dependencies
RUN yarn install
RUN yarn global add esbuild

# Copy Gemfile and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the application
COPY . .

# Create a volume for node_modules to persist
VOLUME /app/node_modules

# Create entrypoint script to set correct permissions
RUN echo '#!/bin/bash\n\
if [ -n "$USER_ID" ] && [ -n "$GROUP_ID" ]; then\n\
    groupadd -g "$GROUP_ID" -o appgroup 2>/dev/null || true\n\
    useradd -u "$USER_ID" -g "$GROUP_ID" -o -m appuser 2>/dev/null || true\n\
    chown -R "$USER_ID:$GROUP_ID" /app/db/migrate /app/app/assets/builds 2>/dev/null || true\n\
fi\n\
exec "$@"' > /entrypoint.sh && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash", "-c", "./bin/dev"]
