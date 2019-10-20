#!/bin/bash
aws lambda invoke --function-name whosonline --payload '{"type":"message"}'
sleep 2
