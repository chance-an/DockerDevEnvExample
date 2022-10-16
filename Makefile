#!make

define setup_env
    $(eval ENV_FILE := $(1).env)
    @echo " - load env $(ENV_FILE)"
    $(eval include $(1).env)
    $(eval export)
endef

default:
	@echo "There is no default target. Specify a target to run"

.dev.env:
	@echo "You don't have .dev.env, please copy \".template.env\" as \".dev.env\"."
	exit 1

.PHONY: load_env_vars
load_env_vars: .dev.env
	$(call setup_env, .dev)

.PHONY: precheck
precheck: load_env_vars

build_prod: precheck
	docker build --target base -t jiayuan_dental_prod .

build_bmachine: precheck
	docker build --target build_machine -t jiayuan_dental_build_machine .

build_devenv: precheck
	docker build --target dev_env -t $$JY_DEVENV_DOCKER_HUB_REPO:latest .

release:
	docker push jiayuan_dental_prod

release_bmachine:
	# nothing here
	echo

release_devenv: ensure_docker_login
	docker push $$JY_DEVENV_DOCKER_HUB_REPO:latest

test: precheck
	@echo $$JY_DEVENV_DOCKER_HUB_PASSWORD | docker login -u $$JY_DEVENV_DOCKER_HUB_USERNAME \
     		--password-stdin

.PHONY: ensure_docker_login
ensure_docker_login: precheck
	@result=$$(cat ~/.docker/config.json |  \
	python -c "import sys, json; print(json.load(sys.stdin)['auths']['https://index.docker.io/v1/'])" \
	2>&1 | grep Error); \
	if [ -z "$$result" ]; then \
 		echo Docker login session detected. ; \
	else \
		echo Docker session not found, prepare to login; \
		echo $$JY_DEVENV_DOCKER_HUB_PASSWORD | docker login -u $$JY_DEVENV_DOCKER_HUB_USERNAME \
                     		--password-stdin; \
 	fi; \

