# Zerv Flow Demo

A simple Rust web server built with Axum framework that demonstrates basic API endpoints with JSON responses.

## Features

- ✅ RESTful API endpoints returning JSON
- ✅ Configurable host and port via environment variables
- ✅ Proper logging with tracing
- ✅ Ready for cloud deployment (GCP, AWS, Azure)
- ✅ Comprehensive test suite
- ✅ Docker support

## Quick Start

### Prerequisites

- Rust 1.91.1 or newer
- Docker (optional, for containerized deployment)

### Running Locally

1. Clone the repository:

```bash
git clone <repository-url>
cd zerv-flow-demo-test
```

2. Run the server:

```bash
make run
```

Or manually:

```bash
cargo run
```

The server will start at `http://localhost:3000`

### API Endpoints

#### GET `/`

Returns a welcome message:

```json
{
    "message": "Hello, Axum World!",
    "description": "Welcome to your Rust web server"
}
```

#### GET `/hello`

Returns a simple greeting:

```json
{
    "message": "Hello from Axum!"
}
```

### Configuration

Configure the server using environment variables:

| Variable | Default   | Description              |
| -------- | --------- | ------------------------ |
| `HOST`   | `0.0.0.0` | IP address to bind to    |
| `PORT`   | `3000`    | Port number to listen on |

Example:

```bash
HOST=127.0.0.1 PORT=8080 cargo run
```

### Testing

Run all tests:

```bash
cargo test
```

Run only library tests:

```bash
cargo test --lib
```

Run with specific test output:

```bash
RUST_LOG=debug cargo test
```

### Docker Deployment

1. Build the Docker image:

```bash
docker build -t zerv-flow-demo .
```

2. Run the container:

```bash
docker run -p 8080:8080 zerv-flow-demo
```

### GCP Cloud Run Deployment

1. Build and push to Google Container Registry:

```bash
# Set your project ID
export PROJECT_ID=your-gcp-project-id

# Build and tag the image
docker build -t gcr.io/${PROJECT_ID}/zerv-flow-demo .

# Push to GCR
docker push gcr.io/${PROJECT_ID}/zerv-flow-demo
```

2. Deploy to Cloud Run:

```bash
gcloud run deploy zerv-flow-demo \
  --image gcr.io/${PROJECT_ID}/zerv-flow-demo \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

## Project Structure

```
├── src/
│   ├── lib.rs      # Library code with business logic
│   ├── main.rs     # Binary entry point
│   └── tests/      # Test modules
├── Dockerfile      # Container configuration
├── Makefile        # Build and run commands
└── Cargo.toml      # Rust dependencies
```

### Key Modules

- **`create_app()`**: Creates and configures the Axum router
- **`handler()`**: Handles requests to the root endpoint
- **`hello_handler()`**: Handles requests to `/hello`
- **`get_server_address()`**: Reads configuration from environment
- **`log_server_urls()`**: Logs server URLs with clickable links
- **`init_tracing()`**: Configures structured logging

## Development

### Code Quality

Run linting and formatting:

```bash
make lint
```

Which runs:

- `cargo fmt` - Code formatting
- `cargo clippy` - Linting checks
- `cargo test` - All tests

### Adding New Endpoints

1. Add the handler function in `src/lib.rs`
2. Register the route in `create_app()`
3. Write tests for the new endpoint

Example:

```rust
// In lib.rs
pub async fn new_endpoint() -> Json<Value> {
    Json(json!({"status": "ok"}))
}

// In create_app()
Router::new()
    .route("/", get(handler))
    .route("/hello", get(hello_handler))
    .route("/status", get(new_endpoint))
```

## Dependencies

- **axum** - Web framework
- **tokio** - Async runtime
- **serde_json** - JSON serialization
- **tracing** - Structured logging
- **tower-http** - HTTP middleware (tracing)

### Dev Dependencies

- **axum-test** - Test utilities
- **reqwest** - HTTP client for integration tests
- **tokio-test** - Async test utilities
- **reserve-port** - Port management for tests

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
