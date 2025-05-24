# Use specific Alpine version for reproducibility
FROM alpine:3.21

# Install dependencies and create virtualenv in a single layer
RUN apk add --no-cache python3 py3-pip bash && \
    python3 -m venv /venv

# Install build dependencies if needed (for packages with C extensions)
# RUN apk add --no-cache --virtual .build-deps python3-dev gcc musl-dev

# Install Python dependencies
COPY ./webapp/requirements.txt /tmp/requirements.txt
RUN /venv/bin/pip install --no-cache-dir -r /tmp/requirements.txt

# Clean up build dependencies if you added them
# RUN apk del .build-deps

# Add application code
COPY ./webapp /opt/webapp/
WORKDIR /opt/webapp

# Create a non-root user and switch to it
RUN adduser -D myuser
#  \
#     chown -R myuser:myuser /opt/webapp /venv
USER myuser

# Run the application
CMD gunicorn --bind 0.0.0.0:${PORT:-5000} wsgi