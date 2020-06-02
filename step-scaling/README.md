## Step scaling
The step scaling sample uses the incomingRecords metric for the source Kinesis data stream source to proportionately configure the parallelism of the associated KDA application. The following subsections describe the key components behind the scaling approach.

### Deployment

Ensure that the KDA app that you'd like to scale has already been deployed. Open up the file [`create-step-scaling-stack.sh`](create-step-scaling-stack.sh) and edit the values `[AWS-REGION]`, `[CFN-STEPSCALING-STACKNAME]`, `[KDA-APP]` and `[KINESIS-STREAM]` to reflect your AWS region, CFN stack name, KDA app and Kinesis stream respectively. 

Then run the bash script to deploy the scaling stack against your KDA app:

```
./create-step-scaling-stack.sh
```