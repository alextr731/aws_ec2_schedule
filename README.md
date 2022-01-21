## AWS EC2 Schedule
Example infrastructure for AWS EC2
### Project include:
- Terraform for IaaC
- basic AWS infrastructure
- schedule script

### How to use:
1. Set Terraform local variable for start and stop time:
	- example: 10:00-20:00
2. Run Terraform
	-	terraform apply
3. Check state of EC2
	- you can use AWS CLI or AWS Console
4. Destroy Terraform
	-	terraform destroy

### Tech stack
- AWS CLI
- at
- bash
- Terraform

