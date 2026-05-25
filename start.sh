#!/bin/bash

# Railway startup script for Django backend
echo "🚀 Starting Hirely Django Backend..."

# Change to Django directory
cd backend/HirelyBackend

# Install dependencies
echo "📦 Installing Python dependencies..."
pip install -r requirements.txt

# Run Django setup
echo "🗃️ Running database migrations..."
python manage.py migrate

echo "📁 Collecting static files..."
python manage.py collectstatic --noinput

echo "🎯 Starting Gunicorn server..."
gunicorn HirelyBackend.wsgi --bind 0.0.0.0:$PORT