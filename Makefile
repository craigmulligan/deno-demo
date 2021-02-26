run: build
	docker stop deno-demo || true && docker rm deno-demo || true && docker run -d -p 8000:8000 --name deno-demo deno-demo 

build:
	docker build . -t deno-demo

test: run
	sleep 1 && curl http://localhost:8000

save:
	docker save deno-demo | gzip > deno-demo.tar.gz

size_uncompressed:
	docker images deno-demo

size_compressed: save
	ls -lh deno-demo.tar.gz
