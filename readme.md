# Terraform-managed Lambda log groups

* set AWS_REGION and AWS_DEFAULT_REGION (```export AWS_REGION=eu-west-1 && export AWS_DEFAULT_REGION=$AWS_REGION```)

## Lambda-managed log groups (default case)

* ```terraform apply```
* ```FUNCTION_NAME=$(terraform output function_name)```
* ```aws lambda invoke --function-name $FUNCTION_NAME --payload '{"param": "World"}' >(cat)```

```
{"value":"Hello World"}{
    "StatusCode": 200,
    "ExecutedVersion": "$LATEST"
}
```

* ```aws logs describe-log-groups --log-group-name-prefix /aws/lambda/$FUNCTION_NAME```

```
{
"logGroups": [
{
            "logGroupName": "/aws/lambda/d696e739f1a18cda-function",
            "creationTime": 1576232093472,
            "metricFilterCount": 0,
            "arn": "arn:aws:logs:eu-west-1:123456789012:log-group:/aws/lambda/d696e739f1a18cda-function:*",
            "storedBytes": 0
        }
    ]
}
```

* ```terraform destroy```
* ```aws logs describe-log-groups --log-group-name-prefix /aws/lambda/$FUNCTION_NAME```

```
{
"logGroups": [
{
            "logGroupName": "/aws/lambda/d696e739f1a18cda-function",
            "creationTime": 1576232093472,
            "metricFilterCount": 0,
            "arn": "arn:aws:logs:eu-west-1:123456789012:log-group:/aws/lambda/d696e739f1a18cda-function:*",
            "storedBytes": 0
        }
    ]
}
```

## Lambda without without CreateLogGroup permission

* ```terraform apply```
* ```FUNCTION_NAME_WO_PERM=$(terraform output function_name_without_createloggroup)```
* ```aws lambda invoke --function-name $FUNCTION_NAME_WO_PERM --payload '{"param": "World"}' >(cat)```

```
{"value":"Hello World"}{
    "StatusCode": 200,
    "ExecutedVersion": "$LATEST"
}
```

* ```aws logs describe-log-groups --log-group-name-prefix /aws/lambda/$FUNCTION_NAME_WO_PERM```

```
{
    "logGroups": []
}
```

* ```terraform destroy```
* ```aws logs describe-log-groups --log-group-name-prefix /aws/lambda/$FUNCTION_NAME_WO_PERM```

```
{
    "logGroups": []
}
```

## Lambda without CreateLogGroup permission and Terraform-managed log group

* ```terraform apply```
* ```FUNCTION_NAME_WO_PERM_W_RES=$(terraform output function_name_without_createloggroup_with_resource)```
* ```aws lambda invoke --function-name $FUNCTION_NAME_WO_PERM_W_RES --payload '{"param": "World"}' >(cat)```

```
{"value":"Hello World"}{
    "StatusCode": 200,
    "ExecutedVersion": "$LATEST"
}
```

* ```aws logs describe-log-groups --log-group-name-prefix /aws/lambda/$FUNCTION_NAME_WO_PERM_W_RES```

```
{
"logGroups": [
{
            "logGroupName": "/aws/lambda/without-createloggroup-with-resource-d696e739f1a18cda-function",
            "creationTime": 1576232060718,
            "retentionInDays": 14,
            "metricFilterCount": 0,
            "arn": "arn:aws:logs:eu-west-1:123456789012:log-group:/aws/lambda/without-createloggroup-with-resource-d696e739f1a18cda-function:*",
            "storedBytes": 0
        }
    ]
}
```

* ```terraform destroy```
* ```aws logs describe-log-groups --log-group-name-prefix /aws/lambda/$FUNCTION_NAME_WO_PERM_W_RES```

```
{
    "logGroups": []
}
```
