SHELL=/bin/bash
.SHELLFLAGS=-euo pipefail -c

SHORT_SHA=$(shell git rev-parse --short HEAD)
VERSION?=${SHORT_SHA}
IMAGE_ORG="quay.io/app-sre"

# App Interface specific push-images target, to run within a docker container.
app-interface-push-images:
	@echo "-------------------------------------------------"
	@echo "running in app-interface-push-images container..."
	@echo "-------------------------------------------------"
	$(eval IMAGE_NAME := app-interface-push-images)
	@(docker build --network=host -t "${IMAGE_ORG}/${IMAGE_NAME}:${VERSION}" -f "config/images/${IMAGE_NAME}.Containerfile" --pull .; \
		docker run --rm \
			--privileged \
			-e JENKINS_HOME=${JENKINS_HOME} \
			-e QUAY_USER=${QUAY_USER} \
			-e QUAY_TOKEN=${QUAY_TOKEN} \
			-e VERSION=${VERSION} \
			-e IMAGE_ORG="${IMAGE_ORG}" \
			-e REMOTE_PHASE_MANAGER_IMAGE="${IMAGE_ORG}/package-operator-hs-connector:${VERSION}" \
			-e REMOTE_PHASE_PACKAGE_IMAGE="${IMAGE_ORG}/package-operator-hs-package:${VERSION}" \
			-e CLI_IMAGE="${IMAGE_ORG}/package-operator-cli:${VERSION}" \
			-e PKO_PACKAGE_NAMESPACE_OVERRIDE="openshift-package-operator" \
			"${IMAGE_ORG}/${IMAGE_NAME}:${VERSION}" \
			./mage build:pushImages; \
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
	git merge -Xtheirs redhat
	git push https://devtools-bot:${GITLAB_TOKEN}@gitlab.cee.redhat.com/lp-sre/package-operator.git main internal
