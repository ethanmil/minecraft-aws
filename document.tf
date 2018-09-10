resource "aws_ssm_document" "backup" {
  name          = "backup"
  document_type = "Command"

  content = <<DOC
  {
    "schemaVersion": "1.2",
    "description": "Check ip configuration of a Linux instance.",
    "parameters": {

    },
    "runtimeConfig": {
      "aws:runShellScript": {
        "properties": [
          {
            "id": "0.aws:runShellScript",
            "runCommand": ["bash backup_world.sh"]
          }
        ]
      }
    }
  }
DOC
}