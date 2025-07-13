# Docker Dev Env for Python Flask - Sports Betting Calculator API

A Flask-based REST API for sports betting calculations including payouts, stakes, odds, and effective odds after fees. This project uses Docker for containerization and includes a git submodule for the main application code.

## Table of Contents

- [Getting Started](#getting-started)
- [Checking Out the Code](#checking-out-the-code)
- [Building with Docker](#building-with-docker)
- [Building without Docker](#building-without-docker)
- [Running Tests](#running-tests)
- [Running the Flask App](#running-the-flask-app)
- [API Documentation](#api-documentation)
- [Project Structure](#project-structure)

## Getting Started

This project requires:
- Git (with submodule support)
- Docker (recommended) OR Python 3.13+ with pip
- Bash shell for running scripts

## Checking Out the Code

This project uses a git submodule for the main application code. The `app/` directory is a submodule pointing to the `betcalc` repository.

### Clone with submodules (recommended)
```bash
git clone --recurse-submodules https://github.com/pwalkernh/docker-python-pip-flask.git
cd docker-python-pip-flask
```

### Clone then initialize submodules
```bash
git clone https://github.com/pwalkernh/docker-python-pip-flask.git
cd docker-python-pip-flask
git submodule update --init --recursive
```

### Updating submodules
```bash
# Update to latest commit on tracked branch
git submodule update --remote

# Update to specific commit
cd app
git checkout <commit-hash>
cd ..
git add app
git commit -m "Update submodule to specific version"
```

## Building with Docker

### Build the Docker image
```bash
./build_docker.sh my_app
```

This creates a Docker image named `my_app` with all dependencies installed.

## Building without Docker

### Install Python dependencies
```bash
pip install -r requirements.txt
```

### Initialize the database (for legacy todo app only)
```bash
python -c "from app import app, db; app.app_context().push(); db.create_all()"
```

## Running Tests

### With Docker (recommended)
```bash
# Run all tests
./build_docker.sh my_app
docker run -t my_app ./run_tests.sh
```

### Run specific test
```bash
docker run -t my_app ./run_tests.sh TestBettingCalculator.test_decimal_to_american_odds
```

### Without Docker
```bash
# Run all tests using the test runner script
./run_tests.sh

# Or run individual test files
python unit_tests.py  # Legacy todo app tests
cd app && python tests/unit_tests.py  # Betting calculator tests
cd app && python tests/test_api.py    # API endpoint tests
cd app && python tests/test_capper_tracker.py  # Expert picks tests
```

## Running the Flask App

### With Docker (recommended)
```bash
# Build the image
./build_docker.sh my_app

# Run with hot reloading (development)
docker run --network=host -v .:/app -t my_app flask run

# Run in production mode
docker run -p 5000:5000 my_app
```

### Without Docker
```bash
# For the betting calculator API (main app)
cd app
export FLASK_APP=app.py
export FLASK_ENV=development  # for development mode
flask run --host=0.0.0.0 --port=5000

# For the legacy todo app (root directory)
export FLASK_APP=app.py
flask init_db  # Initialize database first
flask run --host=0.0.0.0 --port=5000
```

The API will be available at `http://localhost:5000`

## API Documentation

### Swagger/OpenAPI Documentation
Once the Flask app is running, view the interactive API documentation at:
- **Swagger UI**: `http://localhost:5000/static/openapi/openapi.yml` (raw spec)
- **API Info**: `http://localhost:5000/` (basic endpoint information)

### Available Endpoints
- `POST/GET /calculate/payout` - Calculate payout from odds and stake
- `POST/GET /calculate/stake` - Calculate stake from odds and payout  
- `POST/GET /calculate/odds` - Calculate odds from stake and payout
- `POST/GET /calculate/effective_odds` - Calculate effective odds after fee adjustment
- `POST/GET /fetch/expert-picks` - Fetch expert picks data from SportsLine API

### Example API Usage
```bash
# Calculate payout
curl -X POST http://localhost:5000/calculate/payout \
  -H "Content-Type: application/json" \
  -d '{"odds": "+150", "stake": 100}'

# Or using GET
curl "http://localhost:5000/calculate/payout?odds=%2B150&stake=100"
```

## Project Structure

```
.
├── README.md                 # This file
├── Dockerfile               # Docker container configuration
├── requirements.txt         # Python dependencies
├── build_docker.sh         # Docker build script
├── run_tests.sh            # Test runner script
├── unit_tests.py           # Legacy test file
├── .gitmodules             # Git submodule configuration
└── app/                    # Submodule: betcalc repository
    ├── app.py              # Main Flask application
    ├── calculator.py       # Betting calculation logic
    ├── capper_tracker.py   # Expert picks functionality
    ├── tests/              # Test files
    ├── static/             # Static files including OpenAPI spec
    └── README.md           # App-specific documentation
```

The `app/` directory is a git submodule pointing to `https://github.com/pwalkernh/betcalc`.
