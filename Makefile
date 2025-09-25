.PHONY: help init plan apply destroy validate format clean

# Default target
help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

init: ## Initialize Terraform
	terraform init

validate: ## Validate Terraform configuration
	terraform validate

format: ## Format Terraform files
	terraform fmt -recursive

plan: ## Show Terraform deployment plan
	terraform plan

apply: ## Apply Terraform configuration
	terraform apply

destroy: ## Destroy Terraform infrastructure
	terraform destroy

clean: ## Clean Terraform cache and state
	rm -rf .terraform/
	rm -f .terraform.lock.hcl
	rm -f terraform.tfplan

output: ## Show Terraform outputs
	terraform output

refresh: ## Refresh Terraform state
	terraform refresh

show: ## Show current state
	terraform show

graph: ## Generate dependency graph
	terraform graph | dot -Tpng > graph.png

docs: ## Generate documentation
	@echo "Opening README.md..."
	@if command -v code >/dev/null 2>&1; then \
		code README.md; \
	else \
		cat README.md; \
	fi

# Quick deployment workflow
deploy: init validate plan apply ## Full deployment workflow

# Quick cleanup
nuke: destroy clean ## Destroy infrastructure and clean cache