COMMIT_HASH = $(shell git rev-parse HEAD)
BUILD_TIME  = $(shell date +%F.%s)
PROJECTS    ?= service
LOCAL_NAME  ?= snoh-aalegra

all: login build tag push

login:
	aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 264318998405.dkr.ecr.us-west-2.amazonaws.com

build:
	docker build --build-arg COMMIT_HASH=$(COMMIT_HASH) --build-arg BUILD_TIME=$(BUILD_TIME) -t $(LOCAL_NAME):$(COMMIT_HASH) .

run:
	docker run -it --rm -d -p 15000:8080 --name $(LOCAL_NAME) $(LOCAL_NAME):$(COMMIT_HASH)

stop:
	docker stop $(LOCAL_NAME) || echo ":D"

open:
	open http://localhost:15000

tag:
	$(foreach project, $(PROJECTS), docker tag $(LOCAL_NAME):$(COMMIT_HASH) 264318998405.dkr.ecr.us-west-2.amazonaws.com/$(project):current;)
	$(foreach project, $(PROJECTS), docker tag $(LOCAL_NAME):$(COMMIT_HASH) 264318998405.dkr.ecr.us-west-2.amazonaws.com/$(project):$(COMMIT_HASH);)

push:
	$(foreach project, $(PROJECTS), docker push 264318998405.dkr.ecr.us-west-2.amazonaws.com/$(project);)

blue green json:
	cp index.$@.html index.html
	git add .
	git commit -m "Deploy $@"
	git push

