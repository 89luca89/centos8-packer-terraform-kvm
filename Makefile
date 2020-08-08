THISDIR := $(notdir $(CURDIR))
PROJECT := $(THISDIR)


apply: ## applies this
	cd terraform &&	terraform apply -auto-approve

init: ## first time
	cd terraform &&	terraform init

destroy:
	cd terraform &&	terraform destroy -auto-approve

## create public/private keypair for ssh
create-keypair:
	@echo "THISDIR=$(THISDIR)"
	ssh-keygen -t rsa -b 4096 -f id_rsa -C $(PROJECT) -N "" -q

metadata:
	cd terraform &&	terraform refresh && terraform output ips

iso:
	cd packer && packer build centos8.json
	cp -f packer/artifacts/qemu/packer-template-centos8-x86_64 ~/VirtualMachines/centos8-terraform.qcow2

## list make targets
## https://stackoverflow.com/questions/4219255/how-do-you-get-the-list-of-targets-in-a-makefile
list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'
