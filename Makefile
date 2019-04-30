# define default target (which will be run if only 'make' command with no targets issued)
.DEFAULT_GOAL := help

# VARIABLES
ENVIRONMENT ?= dev
AWS_STACK_NAME=redirect-${ENVIRONMENT}
AWS_REGION=eu-west-1
AWS_PROFILE=jnupponen-${ENVIRONMENT}
AWS_S3_BUCKET_NAME=${AWS_STACK_NAME}-artifacts
# TARGETS

# Taken from http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## Prints this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

init: ## Initialize projet and S3 Bucket for SAM deployment
	aws s3 mb s3://${AWS_S3_BUCKET_NAME} --profile ${AWS_PROFILE} --region ${AWS_REGION}

deploy: sam_package sam_deploy sam_outputs ## Deploy application

sam_package:
	AWS_PROFILE=${AWS_PROFILE} sam package \
		--output-template-file packaged.yaml \
		--s3-bucket ${AWS_S3_BUCKET_NAME}

sam_deploy: sam_package
	AWS_PROFILE=${AWS_PROFILE} sam deploy \
		--parameter-overrides "MyEnvironment=${ENVIRONMENT}" \
		--template-file packaged.yaml \
		--stack-name ${AWS_STACK_NAME} \
		--capabilities CAPABILITY_IAM \
		--no-fail-on-empty-changeset

sam_outputs: ## Get SAM stack outputs
	AWS_PROFILE=${AWS_PROFILE} aws cloudformation describe-stacks \
		--stack-name ${AWS_STACK_NAME} \
		--query 'Stacks[].Outputs'

