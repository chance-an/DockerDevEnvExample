default:
	@echo "There is no default target. Specify a target to run"

build_prod:
	docker build --target base -t jiayuan_dental_prod .

build_bmachine:
	docker build --target build_machine -t jiayuan_dental_build_machine .

build_devenv:
	docker build --target dev_env -t jiayuan_dental_devenv .

release:
	docker push jiayuan_dental_prod
