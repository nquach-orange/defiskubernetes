# Use the official Python image from the Docker Hub
FROM python:3.8-alpine

# Set environment variables to prevent Python from buffering outputs and setting it to UTC timezone
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV TZ=UTC

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies
RUN apk update && apk add --no-cache \
    gcc \
    musl-dev \
    postgresql-dev \
    libffi-dev \
    jpeg-dev \
    zlib-dev \
    tzdata \
    && apk add --no-cache bash

# Install the Python dependencies
COPY requirements.txt /app/
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy the entire Django project into the container
COPY Librairie /app/

# Command to run the Django development server
EXPOSE 5002

CMD ["sh", "-c", "python manage.py makemigrations &&\
                python manage.py migrate && \
                python manage.py runserver 0.0.0.0:5002"]