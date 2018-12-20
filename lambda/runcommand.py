import json
import logging
from botocore.exceptions import ClientError
import boto3

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
    
def send_run_command(instance_ids, event):
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
            DocumentName="runcommand",
            Parameters={
              'script': [event['script']],
              'args': [event['args']]
            }
        )
        LOGGER.info('============RunCommand sent successfully')
        return True
    except ClientError as err:
        if 'ThrottlingException' in str(err):
            LOGGER.info("RunCommand throttled, automatically retrying...")
            send_run_command(instance_ids, event)
        else:
            LOGGER.error("Run Command Failed!\n%s", str(err))
            return False
    
def lambda_handler(event, _context):
    """
    Lambda main handler
    """
    LOGGER.info(event)
    instance_ids = find_instances()
    send_run_command(instance_ids, event)
