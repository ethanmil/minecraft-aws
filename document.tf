
resource "aws_ssm_document" "runcommand" {
  name          = "runcommand"
  document_type = "Command"

  content = <<DOC
  {
    "schemaVersion": "1.2",
    "description": "Runs a command on the MineCraft Server.",
    "parameters": {
      "script": {
        "type": "String",
        "description": "File name of the script to run"
      },
      "args": {
            "type": "String",
            "description": "Arguments for bash"
        }
    },
    "runtimeConfig": {
      "aws:runShellScript": {
        "properties": [
          {
            "id": "0.aws:runShellScript",
            "runCommand": ["bash scripts/{{ script }}.sh ${var.S3_BUCKET_NAME} {{ args }}"],
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
            "runCommand": ["bash whos_online.sh ${var.S3_BUCKET_NAME}"],
            "workingDirectory":"/home/ubuntu/scripts"
          }
        ]
      }
    }
  }
DOC
}