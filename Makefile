
BASE_IMAGE := debian:buster-slim
TEMPLATE_FILE := debian.dockerfile
USER := pusnow

BUILD = build
FILE_NAME = $(subst :,_,$(BASE_IMAGE))
DOCKER_FILE = $(BUILD)/$(FILE_NAME).dockerfile

.PHONY: clean docker-build docker-push

docker-build: $(DOCKER_FILE)
	docker build --pull --tag $(USER)/$(BASE_IMAGE) -f $(DOCKER_FILE) .

push: docker-build
	docker push $(USER)/$(BASE_IMAGE)

$(DOCKER_FILE): $(BUILD)
	sed 's/{BASE_IMAGE}/${BASE_IMAGE}/g' $(TEMPLATE_FILE) > $(DOCKER_FILE)

$(BUILD):
	mkdir -p $(BUILD)


clean:
	rm -rf build