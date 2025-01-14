# Multi-stage build for smaller image
FROM python:3.7-alpine AS builder

LABEL authors="Ameer Abdulaziz"

WORKDIR /app

COPY requirements.txt .

RUN pip install --prefix=/install -r requirements.txt

# Final image
FROM python:3.7-alpine

WORKDIR /app

# Create a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

COPY --from=builder /install /usr/local
COPY . .

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONHASHSEED=random

EXPOSE 8000

ENTRYPOINT ["python", "hello.py"]