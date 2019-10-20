import json
import logging
from botocore.exceptions import ClientError
import boto3
import time

LOGGER = logging.getLogger()
LOGGER.setLevel(logging.INFO)

def find_instances():
    """
    Find Instances to invoke Run Command against
    """
    instance_ids = []
    filters = [
        {'Name': 'tag:Name', 'Values': ['Minecraft Server']},
        {'Name': 'instance-state-name', 'Values': ['running']}
    ]
    try:
        instance_ids = find_instance_ids(filters)
        print(instance_ids)
    except ClientError as err:
        LOGGER.error("Failed to DescribeInstances with EC2!\n%s", err)

    return instance_ids
    
def find_instance_ids(filters):
    """
    EC2 API calls to retrieve instances matched by the filter
    """
    ec2 = boto3.resource('ec2')
    return [i.id for i in ec2.instances.all().filter(Filters=filters)]
    
def send_run_command(instance_ids, document):
    """
    Tries to queue a RunCommand job.  If a ThrottlingException is encountered
    recursively calls itself until success.
    """
    try:
        ssm = boto3.client('ssm')
    except ClientError as err:
        LOGGER.error("Run Command Failed!\n%s", str(err))
        return False

    try:
        ssm.send_command(
            InstanceIds=instance_ids,
            DocumentName=document
        )
        LOGGER.info('============RunCommand sent successfully')
        return True
    except ClientError as err:
        if 'ThrottlingException' in str(err):
            LOGGER.info("RunCommand throttled, automatically retrying...")
            send_run_command(instance_ids, document)
        else:
            LOGGER.error("Run Command Failed!\n%s", str(err))
            return False

def get_whos_online():
    try:
        res = ""
        numofplayers = 0
        s3 = boto3.client('s3')
        file = s3.get_object(Bucket = "miller-minecraft-backup", Key = "logs/whosonline.log")
        content = file["Body"].read().decode('utf-8')
        logs = content.splitlines()
        for log in logs:
            if 'join' in log:
                numofplayers += 1
                print('Online: ' + log.split(' ', 1)[0])
                res += log.split(' ', 1)[0] + " "
        print('CONTENT: ' + content)
        if numofplayers < 1:
            res = "No one is on the server"
        elif numofplayers == 1:
            res += "is on the server"
        else:
            res += "are on the server"
        return res;
    except ClientError as err:
        LOGGER.error("Run Command Failed!\n%s", str(err))
        return False
        
def genAlexaJSON(res):
    return {
        'version': '1.0',
        'response': {
            'outputSpeech': {
                'type': 'PlainText',
                'text': res
            },
            'shouldEndSession': True
        }
    }

def genMessageJSON(res):
    return {
        'message': res
    }
    
def lambda_handler(event, _context):
    """
    Lambda main handler
    """
    if hasattr(event, 'request'):
        if event['request']['type'] == "LaunchRequest":
            return genAlexaJSON('Hello, what can I help you with today?')
    LOGGER.info(event)
    instance_ids = find_instances()
    send_run_command(instance_ids, 'whosonline')
    time.sleep(1)
    res = get_whos_online()
    if event['type'] == "message":
        return genMessageJSON(res)
    else:
        return genAlexaJSON(res)
