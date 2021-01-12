COMMIT_HASH = $(shell git rev-parse HEAD)
BUILD_TIME  = $(shell date +%F.%s)
PROJECT     ?= highpoint
ENVIRONMENT ?= development
LOCAL_NAME  ?= snoh-aalegra
REGISTRY    ?= 264318998405.dkr.ecr.us-west-2.amazonaws.com
DOMAIN ?= aws.managedkaos.review

all: login build tag push

everything: terraform all test

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
	docker tag $(LOCAL_NAME):$(COMMIT_HASH) $(REGISTRY)/$(PROJECT):$(ENVIRONMENT)
	docker tag $(LOCAL_NAME):$(COMMIT_HASH) $(REGISTRY)/$(PROJECT):$(COMMIT_HASH)

push:
	docker push $(REGISTRY)/$(PROJECT):$(ENVIRONMENT)
	docker push $(REGISTRY)/$(PROJECT):$(COMMIT_HASH)

terraform:
	make -C ../../Terraform-Modules/example/$(ENVIRONMENT)/ init deploy

test:
	./test.sh "https://$(PROJECT)-$(ENVIRONMENT).$(DOMAIN)"

.PHONY: all everything login build run stop open tag push terraform test
