# Use an official Rust runtime as a parent image
FROM rust:1.63 as builder

# Create a new empty shell project
RUN USER=root cargo new --bin app
WORKDIR /app

# Copy your Cargo.toml and Cargo.lock to the new app
COPY ./Cargo.toml ./Cargo.lock ./

# This step will cache your dependencies
RUN cargo build --release
RUN rm src/*.rs

# Now that the dependency is built, copy your actual source code
COPY ./src ./src

# Build your application
RUN touch src/main.rs
RUN cargo build --release

# Final base
FROM debian:buster-slim
COPY --from=builder /app/target/release/app /usr/src/app
EXPOSE 8000
CMD ["./usr/src/app"]
