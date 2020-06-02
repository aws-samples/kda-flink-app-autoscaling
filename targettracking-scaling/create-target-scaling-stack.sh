#!/bin/bash

REGION=[AWS-REGION]
STACK_NAME=[CFN-TTSCALING-STACKNAME]
KDA_APP_NAME=[KDA-APP]
KINESIS_STREAM_NAME=[KINESIS-STREAM]

if ! aws cloudformation describe-stacks --region $REGION --stack-name $STACK_NAME ; then

    echo -e "\nStack does not exist; creating stack for target tracking scaling..."
    aws cloudformation create-stack \
    --region $REGION \
    --stack-name $STACK_NAME \
    --on-failure DO_NOTHING \
    --capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND \
    --template-body file://targettracking-scaling.yaml \
    --parameters \
      ParameterKey=KDAAppName,ParameterValue=$KDA_APP_NAME \
      ParameterKey=KinesisStreamName,ParameterValue=$KINESIS_STREAM_NAME

fi

# waiting for stack creation to complete...
echo -e "\nWaiting for stack creation to complete..."
aws cloudformation wait stack-create-complete \
    --region $REGION \
    --stack-name $STACK_NAME
echo -e "Stack creation complete"