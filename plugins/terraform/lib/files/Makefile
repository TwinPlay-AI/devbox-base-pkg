args = `arg="$(filter-out $@,$(MAKECMDGOALS))" && echo $${arg:-${1:-}}`
workspace = $${WORKSPACE}

setup: ## Execute terraform init
	chmod +x scripts/*.sh && ./scripts/setup.sh $(workspace)

select-workspace: ## Select terraform workspace
	terraform workspace select $(workspace)

.PHONY: plan
plan: select-workspace ## Execute terraform plan
	terraform plan $(call args,defaultstring) -var-file=env/$(workspace).tfvars

.PHONY: apply
apply: select-workspace ## Execute terraform plan
	terraform apply $(call args,defaultstring) -var-file=env/$(workspace).tfvars

.PHONY: destroy
destroy: select-workspace ## Execute terraform plan
	terraform destroy $(call args,defaultstring) -var-file=env/$(workspace).tfvars

apply-auto-approve: select-workspace ## Execute terraform plan
	terraform apply $(call args,defaultstring) -var-file=env/$(workspace).tfvars -auto-approve

check-drift: ## Check for drift. This will change the meaning of exit codes to: 0 - Succeeded (no changes), 1 - Errored, 2 - Succeeded, there is a diff
	terraform plan $(call args,defaultstring) -var-file=env/$(workspace).tfvars -detailed-exitcode -lock=false

include Makefile.project