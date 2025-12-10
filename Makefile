REPOSITORY ?= registry.codigoaberto.io/backup2s3
VERSION ?= 0.0.1

build:
	docker build -t "${REPOSITORY}:${VERSION}" ./mysql

pull:
	docker pull "${REPOSITORY}:${VERSION}"

push:
	docker push "${REPOSITORY}:${VERSION}"
