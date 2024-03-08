SHELL=/bin/bash
.SHELLFLAGS=-euo pipefail -c

SHORT_SHA=$(shell git rev-parse --short HEAD)
VERSION?=${SHORT_SHA}
REGISTRY_HOST="quay.io"
IMAGE_REGISTRY="${REGISTRY_HOST}/app-sre"

# App Interface specific push-images target, to run within a docker container.
app-interface-push-images:
	@echo "-------------------------------------------------"
	@echo "running in app-interface-push-images container..."
	@echo "-------------------------------------------------"
	$(eval IMAGE_NAME := app-interface-push-images)
	@(docker build --network=host -t "${IMAGE_REGISTRY}/${IMAGE_NAME}:${VERSION}" -f "config/images/${IMAGE_NAME}.Containerfile" --pull . && \
		docker run --network=host --rm \
			--privileged \
			-e JENKINS_HOME=${JENKINS_HOME} \
			-e VERSION=${VERSION} \
			-e IMAGE_REGISTRY="${IMAGE_REGISTRY}" \
			-e REMOTE_PHASE_MANAGER_IMAGE="${IMAGE_REGISTRY}/package-operator-hs-connector:${VERSION}" \
			-e REMOTE_PHASE_PACKAGE_IMAGE="${IMAGE_REGISTRY}/package-operator-hs-package:${VERSION}" \
			-e CLI_IMAGE="${IMAGE_REGISTRY}/package-operator-cli:${VERSION}" \
			"${IMAGE_REGISTRY}/${IMAGE_NAME}:${VERSION}" \
			./do CI:RegistryLoginAndReleaseOnlyImages "${REGISTRY_HOST}" -u "${{ QUAY_USER }}" -p "${{ QUAY_TOKEN }}"; \
	echo) 2>&1 | sed 's/^/  /'
.PHONY: app-interface-push-images

.PHONY: sync-repos
sync-repos:
	git config user.email "merge@bert"
	git config user.name "mergeboy"
	git checkout --detach
	git fetch https://devtools-bot:${GITLAB_TOKEN}@gitlab.cee.redhat.com/lp-sre/package-operator.git internal:internal redhat:redhat
	git fetch https://github.com/package-operator/package-operator.git main:main
	git checkout internal
	git merge -Xtheirs main
	git checkout redhat -- '*'
	git add .
	git commit -m 'sync redhat branch into internal'
	git push https://devtools-bot:${GITLAB_TOKEN}@gitlab.cee.redhat.com/lp-sre/package-operator.git main internal
