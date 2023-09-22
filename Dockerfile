FROM python:3.11-alpine AS base

RUN apk add --no-cache build-base libffi-dev libressl-dev


FROM base AS builder

# Install compilation dependencies and pipenv 
RUN pip install pipenv

# Install python dependencies in /.venv
COPY ./Pipfile .
RUN PIPENV_VENV_IN_PROJECT=1 pipenv install --deploy


FROM base AS runtime

# Copy virtual env from builder stage
COPY --from=builder /.venv /.venv
ENV PATH="/.venv/bin:$PATH"

# Install application into container
COPY . .

# Run the application
ENTRYPOINT ["python", "src/main.py"]
