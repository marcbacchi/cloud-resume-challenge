.PHONY: build

# build:
# 	sam build

deploy-infra:
#	sam build && aws-vault exec crc_user --no-session -- sam deploy
	aws-vault exec Marc -- terraform apply -auto-approve

sync-site:
	aws-vault exec Marc -- aws s3 sync ./resume-site s3://www.marcbacchi.dev

destroy-dynamodb-table:
	aws-vault exec Marc -- terraform destroy --target aws_dynamodb_table.dynamodbtable