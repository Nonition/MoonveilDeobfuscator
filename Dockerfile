# Build with network access once; run individual analysis jobs with --network none.
FROM node:22-bookworm-slim
RUN apt-get update \
    && apt-get install -y --no-install-recommends python3 ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --uid 10001 --create-home analyst
WORKDIR /app
COPY moonveil/ /app/moonveil/
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1
USER 10001:10001
ENTRYPOINT ["python3", "-m", "moonveil"]
