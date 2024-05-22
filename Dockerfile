# Use an official Rust runtime as a parent image
FROM rust:1.63 as builder

# Create a new empty shell project
RUN USER=root cargo new --bin actions-test
WORKDIR /actions-test

# Copy your Cargo.toml and Cargo.lock to the new app
#COPY ./Cargo.toml ./Cargo.lock ./

# This step will cache your dependencies
#RUN cargo build --release
#RUN rm src/*.rs

# Now that the dependency is built, copy your actual source code
#COPY ./src ./src
COPY . /actions-test

# Build your application
#RUN touch src/main.rs
RUN cargo build --release

# Final base
FROM debian:buster-slim
COPY --from=builder /app/target/release/actions-test /usr/src/actions-test
EXPOSE 8000
CMD ["./usr/src/actions-test"]
