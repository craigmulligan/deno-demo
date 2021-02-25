run: build
	docker run -d -p 8000:8000 --name deno-demo deno-demo 

build:
	docker build . -t deno-demo

test: run
	curl http://localhost:8080

size_uncompressed:
	docker images deno-demo
