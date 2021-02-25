# Runtime stage
FROM hayd/alpine-deno:1.7.2

WORKDIR /app/src

# Cache the dependencies as a layer (the following two steps are re-run only when deps.ts is modified).
# Ideally fetch deps.ts will download and compile _all_ external files used in main.ts.
COPY src/deps.ts src/lock.ts ./
RUN deno cache --lock lock.ts deps.ts

# These steps will be re-run upon each file change in your working directory:
ADD ./src/ .

run ls
# Compile the main app so that it doesn't need to be compiled each startup/entry.
RUN deno cache index.ts

RUN deno compile --allow-net --unstable --lite --output server index.ts


# Runtime stage
FROM alpine:latest  
RUN apk --no-cache add ca-certificates
EXPOSE 8000
WORKDIR /root/
COPY --from=0 /app/src/server .
CMD ["./server"]
