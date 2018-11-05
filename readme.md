## Minecraft Server
### Setup
- Add `terraform.tfvars` file to include your variables. For example:
```
AWS_ACCESS_KEY = ""
AWS_SECRET_KEY = ""
AWS_REGION = "us-east-1"
PATH_TO_PUBLIC_KEY = "minecraft-key.pub"
PATH_TO_PRIVATE_KEY = "minecraft-key"
```

- Generate an SSH key as a sibling to the `instance.tf` file -- `ssh-keygen -f minecraft-key` (no passphrase)
- The only AMI mapped in the `vars.tf` file is us-east-1. If you choose a different region, you will have to add an AMI. Keep in mind that SSM agent is automatically installed on the AMI that is mapped. If you choose a different AMI you may have to manually install the SSM agent.

- Run `terraform init` to initialize the directory for terraform (similar to `git init`)