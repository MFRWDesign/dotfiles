# Amazon Bedrock Deployment

Amazon Bedrock provides a fully managed service for deploying Claude Code
in your AWS environment with enterprise-grade security and compliance.

## Prerequisites

Before deploying Claude Code on Amazon Bedrock:

1. **AWS Account** with Bedrock access enabled
2. **IAM Permissions** for Bedrock model access
3. **AWS CLI** configured with appropriate credentials

## Setup Instructions

### Step 1: Enable Bedrock Access

Navigate to the AWS Console and enable Bedrock in your region:

1. Go to Amazon Bedrock console
2. Request model access for Anthropic Claude
3. Wait for approval (usually within minutes)

### Step 2: Configure Credentials

Set up your AWS credentials for Claude Code:

```bash
export AWS_REGION=us-east-1
export AWS_ACCESS_KEY_ID=your-access-key
export AWS_SECRET_ACCESS_KEY=your-secret-key
```

### Step 3: Configure Claude Code

Tell Claude Code to use Bedrock:

```bash
export CLAUDE_CODE_USE_BEDROCK=1
```

## Using Claude Code with Bedrock

Once configured, use Claude Code normally:

```bash
claude -p "Your prompt here"
```

The SDK will automatically route requests through Bedrock.

## Advanced Configuration

For session tokens or assumed roles:

```bash
export AWS_SESSION_TOKEN=your-session-token
```

## Pricing

Bedrock pricing includes:
- Model inference costs
- Data transfer charges
- No minimum fees

## Limitations

- Regional availability varies
- Some features may have different behavior
- Latency depends on region

## Troubleshooting

Common issues:
- "Access Denied" - Check IAM permissions
- "Model not found" - Ensure model access is granted
- "Region error" - Verify Bedrock is available in your region

For more details, see AWS Bedrock documentation.