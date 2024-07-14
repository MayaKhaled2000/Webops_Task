# Base image
FROM ruby:3.3.3

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential nodejs

# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock to the container
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the rest of the application code to the container
COPY . .

# Expose port 3000 (adjust if your Rails app uses a different port)
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]