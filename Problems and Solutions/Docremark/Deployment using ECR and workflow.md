# AWS Lambda Container Deployment Guide

## Overview
This guide walks you through deploying the Docremark API to AWS Lambda using Docker containers. This approach solves the 50MB/250MB zip size limitations by supporting up to 10GB container images.

## Prerequisites
- AWS Account with appropriate permissions
- AWS CLI installed and configured
- Docker installed locally
- GitHub repository with Actions enabled

## Step 1: Create ECR Repository

```bash
# Set your AWS region
export AWS_REGION=us-east-1

# Create ECR repository
aws ecr create-repository \
  --repository-name docremark-api \
  --region $AWS_REGION

# Note the repositoryUri from the output
```

## Step 2: Create IAM Role for GitHub Actions (OIDC - Recommended)

### 2.1 Create OIDC Provider (One-time setup)
```bash
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1
```

### 2.2 Create IAM Role
Create a file `github-actions-trust-policy.json`:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::YOUR_ACCOUNT_ID:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:unwir-dev/docremark:*"
        }
      }
    }
  ]
}
```

Create the role:
```bash
aws iam create-role \
  --role-name GitHubActionsDocremarkDeployRole \
  --assume-role-policy-document file://github-actions-trust-policy.json
```

### 2.3 Attach Policies
```bash
# ECR permissions
aws iam attach-role-policy \
  --role-name GitHubActionsDocremarkDeployRole \
  --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser

# Lambda update permissions - create custom policy
cat > lambda-deploy-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "lambda:UpdateFunctionCode",
        "lambda:UpdateFunctionConfiguration",
        "lambda:GetFunction",
        "lambda:GetFunctionConfiguration"
      ],
      "Resource": "arn:aws:lambda:*:*:function:docremark-api"
    }
  ]
}
EOF

aws iam create-policy \
  --policy-name DocremarkLambdaDeployPolicy \
  --policy-document file://lambda-deploy-policy.json

# Attach the policy (replace ACCOUNT_ID)
aws iam attach-role-policy \
  --role-name GitHubActionsDocremarkDeployRole \
  --policy-arn arn:aws:iam::YOUR_ACCOUNT_ID:policy/DocremarkLambdaDeployPolicy
```

## Step 3: Create Lambda Function with Container Image

```bash
# Create execution role for Lambda
cat > lambda-execution-role-trust-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

aws iam create-role \
  --role-name DocremarkLambdaExecutionRole \
  --assume-role-policy-document file://lambda-execution-role-trust-policy.json

# Attach basic Lambda execution policy
aws iam attach-role-policy \
  --role-name DocremarkLambdaExecutionRole \
  --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

# Attach VPC execution if needed (for RDS access)
aws iam attach-role-policy \
  --role-name DocremarkLambdaExecutionRole \
  --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole

# Build and push initial image
cd apps/api
docker build -f Dockerfile -t docremark-api:latest ../..

# Tag and push to ECR
export ECR_URI=YOUR_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/docremark-api
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URI
docker tag docremark-api:latest $ECR_URI:latest
docker push $ECR_URI:latest

# Create Lambda function
aws lambda create-function \
  --function-name docremark-api \
  --package-type Image \
  --code ImageUri=$ECR_URI:latest \
  --role arn:aws:iam::YOUR_ACCOUNT_ID:role/DocremarkLambdaExecutionRole \
  --timeout 30 \
  --memory-size 1024 \
  --region $AWS_REGION
```

## Step 4: Configure Lambda Environment Variables

```bash
aws lambda update-function-configuration \
  --function-name docremark-api \
  --environment Variables="{
    NODE_ENV=production,
    DATABASE_URL=postgresql://user:pass@host:5432/db,
    AUTH_SECRET=your-secret-here,
    API_URL=https://your-api-url.com
  }"
```

## Step 5: Set up API Gateway (Optional)

```bash
# Create HTTP API
aws apigatewayv2 create-api \
  --name docremark-api \
  --protocol-type HTTP \
  --target arn:aws:lambda:$AWS_REGION:YOUR_ACCOUNT_ID:function:docremark-api

# Grant API Gateway permission to invoke Lambda
aws lambda add-permission \
  --function-name docremark-api \
  --statement-id apigateway-invoke \
  --action lambda:InvokeFunction \
  --principal apigateway.amazonaws.com
```

## Step 6: Configure GitHub Secrets

Go to your GitHub repository → Settings → Secrets and variables → Actions

Add these secrets:
- `AWS_ROLE_ARN`: `arn:aws:iam::YOUR_ACCOUNT_ID:role/GitHubActionsDocremarkDeployRole`
- `DATABASE_URL`: Your production database URL
- Any other environment variables needed

## Step 7: Update Workflow Configuration

Edit `.github/workflows/deploy-api.yml`:
- Update `AWS_REGION` if different
- Update branch triggers if needed
- Verify `ECR_REPOSITORY` and `LAMBDA_FUNCTION_NAME` match

## Step 8: Test Local Build

```bash
# From the monorepo root
cd apps/api

# Build the Docker image
pnpm docker:build

# Run locally with Lambda Runtime Interface Emulator
pnpm docker:run

# In another terminal, test the function
pnpm docker:test
```

## Step 9: Deploy via GitHub Actions

Push to your configured branch (e.g., `release-development`):
```bash
git add .
git commit -m "feat: switch to Lambda container deployment"
git push origin release-development
```

The GitHub Actions workflow will:
1. Build the Docker image
2. Push to ECR
3. Update Lambda function
4. Wait for update to complete

## Monitoring & Debugging

### View Lambda logs
```bash
aws logs tail /aws/lambda/docremark-api --follow
```

### Test Lambda function
```bash
aws lambda invoke \
  --function-name docremark-api \
  --payload '{"rawPath": "/health", "requestContext": {"http": {"method": "GET"}}}' \
  response.json

cat response.json
```

### Update function manually
```bash
# Get latest image URI from ECR
IMAGE_URI=$ECR_URI:release-development-$(git rev-parse HEAD)

aws lambda update-function-code \
  --function-name docremark-api \
  --image-uri $IMAGE_URI
```

## Cost Optimization

1. **Lambda Configuration**:
   - Start with 1024MB memory, adjust based on CloudWatch metrics
   - Set timeout to minimum needed (30s recommended)

2. **ECR Lifecycle Policy**:
```bash
cat > ecr-lifecycle-policy.json << 'EOF'
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep last 10 images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 10
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF

aws ecr put-lifecycle-policy \
  --repository-name docremark-api \
  --lifecycle-policy-text file://ecr-lifecycle-policy.json
```

3. **CloudWatch Logs Retention**:
```bash
aws logs put-retention-policy \
  --log-group-name /aws/lambda/docremark-api \
  --retention-in-days 7
```

## Troubleshooting

### Build fails locally
- Ensure you're running from monorepo root
- Check Docker has enough memory (at least 4GB)
- Verify all workspace dependencies are properly linked

### Lambda timeout
- Increase timeout in Lambda configuration
- Check database connection pooling
- Enable CloudWatch Insights for performance analysis

### Permission errors
- Verify IAM roles have correct policies attached
- Check trust relationships are properly configured
- Ensure GitHub OIDC provider is set up correctly

## Rollback

If deployment fails, rollback to previous image:
```bash
# List recent images
aws ecr describe-images --repository-name docremark-api

# Update to previous image
aws lambda update-function-code \
  --function-name docremark-api \
  --image-uri $ECR_URI:previous-tag
```

## Next Steps

1. Set up CloudWatch alarms for errors and throttling
2. Configure Lambda reserved concurrency if needed
3. Set up API Gateway custom domain
4. Implement Lambda@Edge for global distribution
5. Add AWS WAF for API protection
