resource "aws_ssm_document" "backup" {
  name          = "backup"
  document_type = "Command"

  content = <<DOC
  {
    "schemaVersion": "1.2",
    "description": "Backup Minecraft world to S3.",
    "parameters": {

    },
    "runtimeConfig": {
      "aws:runShellScript": {
        "properties": [
          {
            "id": "0.aws:runShellScript",
            "runCommand": ["bash scripts/backup_world.sh"],
            "workingDirectory":"/home/ubuntu"
          }
        ]
      }
    }
  }
DOC
}

resource "aws_ssm_document" "restore" {
  name          = "restore"
  document_type = "Command"

  content = <<DOC
  {
    "schemaVersion": "1.2",
    "description": "Restores the Minecraft world to the specified backup.",
    "parameters": {
      "date": {
        "type": "String",
        "description": "Date to append to the folder/file name to retrieve the backup"
      }
    },
    "runtimeConfig": {
      "aws:runShellScript": {
        "properties": [
          {
            "id": "0.aws:runShellScript",
            "runCommand": ["bash scripts/restore_world.sh {{ date }}"],
            "workingDirectory":"/home/ubuntu"
          }
        ]
      }
    }
  }
DOC
}

resource "aws_ssm_document" "whosonline" {
  name          = "whosonline"
  document_type = "Command"

  content = <<DOC
  {
    "schemaVersion": "1.2",
    "description": "Checks who is online and uploads the result to S3.",
    "parameters": {
    },
    "runtimeConfig": {
      "aws:runShellScript": {
        "properties": [
          {
            "id": "0.aws:runShellScript",
            "runCommand": ["bash whos_online.sh"],
            "workingDirectory":"/home/ubuntu/scripts"
          }
        ]
      }
    }
  }
DOC
}