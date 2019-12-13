AWS_REGION, AWS_DEFAULT_REGION (elso terraform, masodik cli)
terraform apply

FUNCTION_NAME=$(terraform output function_name)
FUNCTION_NAME_WO_PERM=$(terraform output function_name_without_createloggroup)
FUNCTION_NAME_WO_PERM_W_RES=$(terraform output function_name_without_createloggroup_with_resource)

invoke

aws lambda invoke --function-name $FUNCTION_NAME --payload '{"param": "World"}' >(cat)
{"value":"Hello World"}{
    "StatusCode": 200,
    "ExecutedVersion": "$LATEST"
}
aws lambda invoke --function-name $FUNCTION_NAME_WO_PERM --payload '{"param": "World"}' >(cat)
{"value":"Hello World"}{
    "StatusCode": 200,
    "ExecutedVersion": "$LATEST"
}
aws lambda invoke --function-name $FUNCTION_NAME_WO_PERM_W_RES --payload '{"param": "World"}' >(cat)
{"value":"Hello World"}{
    "StatusCode": 200,
    "ExecutedVersion": "$LATEST"
}

aws logs describe-log-groups --log-group-name-prefix /aws/lambda/$FUNCTION_NAME
{
"logGroups": [
{
            "logGroupName": "/aws/lambda/d696e739f1a18cda-function",
            "creationTime": 1576232093472,
            "metricFilterCount": 0,
            "arn": "arn:aws:logs:eu-west-1:757253985935:log-group:/aws/lambda/d696e739f1a18cda-function:*",
            "storedBytes": 0
        }
    ]
}
aws logs describe-log-groups --log-group-name-prefix /aws/lambda/$FUNCTION_NAME_WO_PERM
{
    "logGroups": []
}
aws logs describe-log-groups --log-group-name-prefix /aws/lambda/$FUNCTION_NAME_WO_PERM_W_RES
{
"logGroups": [
{
            "logGroupName": "/aws/lambda/without-createloggroup-with-resource-d696e739f1a18cda-function",
            "creationTime": 1576232060718,
            "retentionInDays": 14,
            "metricFilterCount": 0,
            "arn": "arn:aws:logs:eu-west-1:757253985935:log-group:/aws/lambda/without-createloggroup-with-resource-d696e739f1a18cda-function:*",
            "storedBytes": 0
        }
    ]
}
 retentionInDays be van allitva!
 terraform destroy
aws logs describe-log-groups --log-group-name-prefix /aws/lambda/$FUNCTION_NAME
{
"logGroups": [
{
            "logGroupName": "/aws/lambda/d696e739f1a18cda-function",
            "creationTime": 1576232093472,
            "metricFilterCount": 0,
            "arn": "arn:aws:logs:eu-west-1:757253985935:log-group:/aws/lambda/d696e739f1a18cda-function:*",
            "storedBytes": 0
        }
    ]
}
aws logs describe-log-groups --log-group-name-prefix /aws/lambda/$FUNCTION_NAME_WO_PERM
{
    "logGroups": []
}
aws logs describe-log-groups --log-group-name-prefix /aws/lambda/$FUNCTION_NAME_WO_PERM_W_RES
{
    "logGroups": []
}

 does not work for lambda@edge!
 az minden regioban letrehoz egy log groupot magatol


