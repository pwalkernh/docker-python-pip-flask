FROM python:3.13.2-slim

# Install system dependencies for Firefox
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    unzip \
    curl \
    xvfb \
    firefox-esr \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install geckodriver
RUN wget -q "https://github.com/mozilla/geckodriver/releases/download/v0.33.0/geckodriver-v0.33.0-linux64.tar.gz" \
    && tar -xzf geckodriver-v0.33.0-linux64.tar.gz \
    && mv geckodriver /usr/local/bin/ \
    && chmod +x /usr/local/bin/geckodriver \
    && rm geckodriver-v0.33.0-linux64.tar.gz \
    && ls -la /usr/local/bin/geckodriver \
    && /usr/local/bin/geckodriver --version

# Set environment variables for Firefox
ENV DISPLAY=:99

WORKDIR /app
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt
COPY run_tests.sh unit_tests.py ./
COPY app ./
ENV FLASK_APP=app.py
CMD ["flask", "run", "--host", "0.0.0.0", "--port", "5000"]
