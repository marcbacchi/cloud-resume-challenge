.PHONY: build

# build:
# 	sam build

deploy-infra:
#	sam build && aws-vault exec crc_user --no-session -- sam deploy
	aws-vault exec Marc -- terraform plan

sync-site:
	aws-vault exec Marc -- aws s3 sync ./resume-site s3://www.marcbacchi.dev

