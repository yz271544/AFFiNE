IMAGE_TAG= $(shell git describe --tags 2>/dev/null || echo 'v0.0.0')
CURRENT_DATE ?= $(shell date -u +'%Y-%m-%dT%H:%M:%SZ' | cut -c 1-)
REVERSION ?= $(shell git rev-list HEAD -n 1 | cut -c 1-)
PROJECT_LABEL = "AFFiNE"
PLATFORM ?= "linux/amd64"

.PHONY: self-server-image
self-server-image:
	@docker buildx build . --no-cache --load -f .github/deployment/node/Dockerfile -t registry.cn-sh-01.sensecore.cn/tsm_2024052501/affine-graphql:${IMAGE_TAG} --pull --label=org.opencontainers.image.created=${CURRENT_DATE} --label=org.opencontainers.image.title=${PROJECT_LABEL} --label=org.opencontainers.image.revision=${REVERSION} --platform=${PLATFORM}

.PHONY: web-image
web-image:
	@docker buildx build . --load -f .github/deployment/front/Dockerfile -t registry.cn-sh-01.sensecore.cn/tsm_2024052501/affine-web:${IMAGE_TAG} --pull --label=org.opencontainers.image.created=${CURRENT_DATE} --label=org.opencontainers.image.title=${PROJECT_LABEL} --label=org.opencontainers.image.revision=${REVERSION} --platform=${PLATFORM}

.PHONY: push-self-server
push-self-server:
	@docker push registry.cn-sh-01.sensecore.cn/tsm_2024052501/affine-graphql:${IMAGE_TAG}

.PHONY: push-web
push-web:
	@docker push registry.cn-sh-01.sensecore.cn/tsm_2024052501/affine-web:${IMAGE_TAG}
