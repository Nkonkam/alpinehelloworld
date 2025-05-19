# Grab the latest alpine image
FROM alpine:latest

# Install Python, pip, and virtualenv
RUN apk add --no-cache python3 py3-pip bash && python3 -m ensurepip && pip3 install --no-cache-dir virtualenv

# Create a virtual environment
RUN python3 -m venv /venv

# Activate the virtual environment and install dependencies
COPY ./webapp/requirements.txt /tmp/requirements.txt
RUN /venv/bin/pip install --no-cache-dir -r /tmp/requirements.txt

# Add the virtual environment to PATH
ENV PATH="/venv/bin:$PATH"

# Add application code
COPY ./webapp /opt/webapp/
WORKDIR /opt/webapp

# Create a non-root user and switch to it
RUN adduser -D myuser
USER myuser

# Run the application
CMD gunicorn --bind 0.0.0.0:${PORT:-5000} wsgi
