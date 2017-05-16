repo_name = jp-migrate
#vault_password = --vault-password-file ~/.secrets/$(repo_name).vault
#ansible_cmd = AWS_PROFILE=$(aws_account) ansible-playbook $(vault_password)
ansible_cmd = AWS_PROFILE=$(aws_account) ansible-playbook

# defaults
aws_account ?= aws1
aws_region ?= us-west-2
commit ?= master
mm_commit ?= master
count ?= 1

ec2-refresh-cache:
	# refresh dynamic inventory
	AWS_PROFILE=$(aws_account) ./inventory/ec2.py --refresh-cache
ec2-provision:
	# launch or terminate EC instances
	$(ansible_cmd) ec2-provision.yml -e env=$(env) -e aws_account=$(aws_account) -e aws_region=$(aws_region) -e role=$(role) -e count=$(count) $(debug) $(limit)
	AWS_PROFILE=$(aws_account) ./inventory/ec2.py --refresh-cache

mongodb-install:
	# install default mongodb
	$(ansible_cmd) mongodb-server.yml -e env=$(env) -e aws_account=$(aws_account) -e aws_region=$(aws_region) -e commit=$(commit) $(debug) $(limit)
