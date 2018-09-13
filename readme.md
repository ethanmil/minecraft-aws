## Minecraft Server

### Setup
- Add `terraform.tfvars` file to include your variables. For example:
```
AWS_ACCESS_KEY = ""
AWS_SECRET_KEY = ""
AWS_REGION = "us-east-1"
PATH_TO_PUBLIC_KEY = "minecraft-key.pub"
PATH_TO_PRIVATE_KEY = "minecraft-key"
S3_BUCKET_NAME = ""
```
- Generate an SSH key as a sibling to the `instance.tf` file
- The only AMI mapped in the `vars.tf` file is us-east-1. If you choose a different region, you will have to add an AMI. Keep in mind that SSM agent is automatically installed on the AMI that is mapped. If you choose a different AMI you may have to manually install the SSM agent.

### Restore
- Command requires an argument: YYYY/MM/world_DD_HH-MM.tar.gz
  - The date/time being the moment the backup was taken of which you want to be restored

- The lambda function gets this argument in the event JSON object. For example 
```
{
  "date":"2018/09/world_11_19-00.tar.gz"
}
```
