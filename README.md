
## Overview
This sample is meant to help users auto-scale their [Kinesis Data Analytics for Java](https://aws.amazon.com/kinesis/data-analytics/) (KDA) applications using [AWS Application Autoscaling](https://docs.aws.amazon.com/autoscaling/application/userguide/what-is-application-auto-scaling.html). KDA currently only supports CPU based autoscaling, and readers can use the guidance in this repo to scale their KDA applications based on other signals - such as operator throughput, for instance.

We've included guidance for both [step scaling](step-scaling/README.md) and [target tracking scaling](targettracking-scaling/README.md). For official documentation on AWS Application Autoscaling, please visit:
- [Step scaling](https://docs.aws.amazon.com/autoscaling/application/userguide/application-auto-scaling-step-scaling-policies.html)
- [Target tracking scaling](https://docs.aws.amazon.com/autoscaling/application/userguide/application-auto-scaling-target-tracking.html)

## Why use Application Autoscaling?
You may be wondering: "Why use Application Autoscaling; why not just trigger a Lambda function via a CloudWatch alarm and SNS?". The main reason is that Application Autoscaling has a well defined API for specifying scaling policies and associated attributes such as cooldown periods. In addition, we can take advantage of all three scaling types included with Application Autoscaling: step scaling, target tracking scaling, and schedule-based scaling (not covered in this doc).

### Application autoscaling of custom resource

AWS Application autoscaling allows users to scale in/out custom resources by specifying a custom endpoint that can be invoked by Application Autoscaling. In this example, this custom endpoint is implemented using API Gateway and an AWS Lambda function. Here's a high level flow depicting this approach:

CW Alarm => Application Autoscaling => Custom Endpoint (API GW + Lambda) => Scale KDA App

### CloudFormation template
The accompanying [CloudFormation template](step-scaling/step-scaling.yaml) takes care of provisioning all of the above components.

### Scaling logic
When invoked by Application Autoscaling, the Lambda function (written in Python) will call [UpdateApplication](https://docs.aws.amazon.com/kinesisanalytics/latest/apiv2/API_UpdateApplication.html) with the desired capacity specified. In addition, it will also re-configure the alarm thresholds to take into account the current parallelism of the KDA application.

You can review the Python code for the Lambda function associated with step scaling [here](step-scaling/index.py) and for target tracking autoscaling [here](targettracking-scaling/index.py).

### Some caveats

1. When scaling out/in, in this sample we only update the overall parallelism; we don't adjust parallelism/KPU.
2. When scaling occurs, the KDA app experiences downtime. Please take this into consideration when configuring the step scaling increments.
3. Please keep in mind that the throughput of a Flink application is dependent on many factors (complexity of processing, destination throughput, etc...). The step-scaling example assumes a simple relationship between incoming record throughput and scaling. And similarly millisBehindLatest for target-tracking autoscaling.
4. Currently, the step-scaling template applies static configurations for when to scale, and applying updates directly to CloudWatch Alarms will be undone on any scaling event. To get around this, ensure that the changes are reflected both in CloudWatch Alarms and in the Lambda scaler.
5. Currently in the step-scaling template, the CloudWatch alarm will treat `missing` data as `missing`, meaning if there is a delay or zero data coming in, your application will not scale in. You can modify this to treat `missing` data as `breaching` if it suits your use case, and remember to apply these changes in the Lambda scaler as well.
