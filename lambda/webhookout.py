import json
from botocore.vendored import requests

def lambda_handler(event, _context):
    webhook_url = event['webhook_url']
    payload = {
        "content": event['message'],
        "tts": "false"
    }
    
    response = requests.post(
        webhook_url, data=json.dumps(payload),
        headers={'Content-Type': 'application/json'}
    )
    if response.status_code != 200:
        raise ValueError(
            'Request returned an error %s, the response is:\n%s'
            % (response.status_code, response.text)
    )