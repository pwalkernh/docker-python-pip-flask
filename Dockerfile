FROM python:3.13.2-alpine3.21@sha256:323a717dc4a010fee21e3f1aac738ee10bb485de4e7593ce242b36ee48d6b352
WORKDIR /app
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt
COPY run_tests.sh unit_tests.py ./
COPY app ./
ENV FLASK_APP=app.py
CMD ["flask", "run", "--host", "0.0.0.0", "--port", "5000"]
