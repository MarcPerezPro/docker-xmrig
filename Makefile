VERSION = 6.21.2
CUDA_PLUGIN_VERSION=6.21.1
CUDA_VERSION=11-4
REL = $(VERSION)
THREADS = $(shell nproc)
PRIORITY = 0
REPO=docker.io/marcperez123/xmrig
CC=docker

HUB=https://hub.docker.com/v2

all: build run

build:
	$(CC) build -t $(REPO):$(REL) --platform=linux/amd64 --build-arg VERSION=$(VERSION) .
	$(CC) tag $(REPO):$(REL) $(REPO):latest

run: build
	$(CC) run --rm -it -e THREADS=$(THREADS) -e PRIORITY=$(PRIORITY) -v $(PWD)/config.json:/xmrig/config.json --entrypoint xmrig $(REPO):$(REL)

run-cuda: build
	$(CC) run \
		--device nvidia.com/gpu=all \
		--device /dev/cpu \
		--device /dev/cpu_dma_latency \
		--security-opt=label=disable \
		--rm -it \
		--cap-add=ALL \
		--privileged \
		-e THREADS=$(THREADS) \
		-e PRIORITY=$(PRIORITY) \
		-e CUDA=true \
		-e NO_CPU=true \
		$(REPO):$(REL)
