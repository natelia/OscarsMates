FROM ruby:3.2.2
# Install nodejs and npm
RUN apt-get update -qq && apt-get install -y \
    nodejs \
    npm \
    sqlite3 \
    build-essential
# Install Yarn
RUN npm install -g yarn
# Create and set working directory
WORKDIR /app
# Copy package.json and yarn.lock first to leverage Docker caching
COPY package.json yarn.lock ./
# Install JS dependencies
RUN yarn install
# Copy Gemfile and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install
# Copy the rest of the application
COPY . .
# Create a volume for node_modules to persist
VOLUME /app/node_modules
