COMMIT_HASH = $(shell git rev-parse HEAD)
BUILD_TIME  = $(shell date +%F.%s)
PROJECTS    ?= highpoint
ENVIRONMENT ?= development
LOCAL_NAME  ?= snoh-aalegra
REGISTRY    ?= 264318998405.dkr.ecr.us-west-2.amazonaws.com

all: login build tag push

login:
	aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin $(REGISTRY)

build:
	docker build --build-arg COMMIT_HASH=$(COMMIT_HASH) --build-arg BUILD_TIME=$(BUILD_TIME) -t $(LOCAL_NAME):$(COMMIT_HASH) .

run:
	docker run -it --rm -d -p 15000:8080 --name $(LOCAL_NAME) $(LOCAL_NAME):$(COMMIT_HASH)

stop:
	docker stop $(LOCAL_NAME) || echo ":D"

open:
	open http://localhost:15000

tag:
	$(foreach project, $(PROJECTS), docker tag $(LOCAL_NAME):$(COMMIT_HASH) $(REGISTRY)/$(project):$(ENVIRONMENT);)
	$(foreach project, $(PROJECTS), docker tag $(LOCAL_NAME):$(COMMIT_HASH) $(REGISTRY)/$(project):$(COMMIT_HASH);)

push:
	$(foreach project, $(PROJECTS), docker push $(REGISTRY)/$(project):$(ENVIRONMENT);)
	$(foreach project, $(PROJECTS), docker push $(REGISTRY)/$(project):$(COMMIT_HASH);)
