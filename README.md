import * as cdk from 'aws-cdk-lib';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import * as apigateway from 'aws-cdk-lib/aws-apigateway';
import * as s3 from 'aws-cdk-lib/aws-s3';
import * as iam from 'aws-cdk-lib/aws-iam';

export class ThreeTierWebsiteStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // Create S3 bucket for static website hosting
    const websiteBucket = new s3.Bucket(this, 'WebsiteBucket', {
      websiteIndexDocument: 'index.html',
      websiteErrorDocument: 'error.html'
    });

    // Create IAM role for Lambda function
    const lambdaRole = new iam.Role(this, 'LambdaRole', {
      assumedBy: new iam.ServicePrincipal('lambda.amazonaws.com')
    });

    // Grant permissions to access S3 bucket
    websiteBucket.grantReadWrite(lambdaRole);

    // Create Lambda function to handle dynamic content
    const lambdaFunction = new lambda.Function(this, 'LambdaFunction', {
      runtime: lambda.Runtime.NODEJS_14_X,
      handler: 'index.handler',
      code: lambda.Code.fromAsset('lambda'),
      role: lambdaRole
    });

    // Create API Gateway REST API
    const restApi = new apigateway.RestApi(this, 'ApiGateway', {
      restApiName: 'ThreeTierWebsiteAPI'
    });

    // Create Lambda integration for API Gateway
    const lambdaIntegration = new apigateway.LambdaIntegration(lambdaFunction);

    // Create API Gateway resources and methods
    const apiResource = restApi.root.addResource('api');
    const getMethod = apiResource.addMethod('GET', lambdaIntegration);

    // Set up S3 bucket policy to allow public read access
    websiteBucket.addToResourcePolicy(new iam.PolicyStatement({
      actions: ['s3:GetObject'],
      effect: iam.Effect.ALLOW,
      principals: [new iam.AnyPrincipal()],
      resources: [websiteBucket.arnForObjects('*')],
      conditions: {
        'IpAddress': {
          'aws:SourceIp': ['0.0.0.0/0']
        }
      }
    }));

    // Output website URL
    new cdk.CfnOutput(this, 'WebsiteUrl', {
      value: websiteBucket.bucketWebsiteUrl,
      description: 'URL for the static website'
    });
  }
}
