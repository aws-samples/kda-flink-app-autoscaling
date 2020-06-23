## Target-tracking scaling
The target tracking scaling sample uses the millisBehindLatest metric for the Kinesis data stream source as the signal to adjust the parallelism of the KDA Flink app. The algorithm is fairly simple: when millisBehindLatest > 1 minute, trigger scale-out. Target tracking autoscaling then scales back in once millisBehindLatest for the KDA Flink consumer drops below 1ms.

### Deployment

Ensure that the KDA app that you'd like to scale has already been deployed. Open up the file [`create-target-scaling-stack.sh`](create-target-scaling-stack.sh) and edit the values `[AWS-REGION]`, `[CFN-TTSCALING-STACKNAME]`, `[KDA-APP]` and `[KINESIS-STREAM]` to reflect your AWS region, CFN stack name, KDA app and Kinesis stream respectively. 

Then run the bash script to deploy the scaling stack against your KDA app:

```
./create-target-scaling-stack.sh
```