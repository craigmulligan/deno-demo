# Build stage
FROM hayd/alpine-deno:1.7.2

WORKDIR /app

# Cache the dependencies as a layer (the following two steps are re-run only when deps.ts is modified).
# Ideally fetch deps.ts will download and compile _all_ external files used in main.ts.
COPY lock.json ./
COPY src/deps.ts ./src/
RUN deno cache --reload --lock=lock.json src/deps.ts

# These steps will be re-run upon each file change in your working directory:
ADD ./src/ ./src/

RUN deno compile --allow-net --unstable --lite --output ./src/server ./src/index.ts

# Runtime stage
FROM frolvlad/alpine-glibc
RUN apk --no-cache add ca-certificates
EXPOSE 8000
WORKDIR /app/src

COPY --from=0 /app/src/ .

RUN ls -lh server

CMD ["/app/src/server"]
