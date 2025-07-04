# Google Vertex AI Deployment

Deploy Claude Code using Google Cloud's Vertex AI for enterprise
machine learning platform integration.

## Prerequisites

Required before setup:

1. **Google Cloud Project** with billing enabled
2. **Vertex AI API** enabled in your project
3. **gcloud CLI** installed and configured

## Setup Instructions

### Step 1: Enable Vertex AI

Enable required APIs in your GCP project:

```bash
gcloud services enable aiplatform.googleapis.com
```

### Step 2: Set Up Authentication

Configure application default credentials:

```bash
gcloud auth application-default login
```

### Step 3: Configure Claude Code

Set environment variables for Vertex AI:

```bash
export CLAUDE_CODE_USE_VERTEX=1
export GOOGLE_CLOUD_PROJECT=your-project-id
export GOOGLE_CLOUD_REGION=us-central1
```

## Using Claude Code with Vertex AI

Once configured, use standard Claude Code commands:

```bash
claude -p "Analyze this code"
```

Requests automatically route through Vertex AI.

## Model Endpoint Configuration

For custom endpoints:

```bash
export VERTEX_AI_ENDPOINT=your-endpoint-url
```

## Features

Vertex AI integration provides:
- VPC Service Controls support
- Cloud Logging integration
- IAM-based access control
- Regional deployment options

## Pricing

Costs include:
- Prediction requests
- Model hosting (if applicable)
- Network egress

## Best Practices

1. Use regional endpoints for lower latency
2. Enable Cloud Logging for debugging
3. Set up budget alerts
4. Use VPC Service Controls for security

## Limitations

- Not all regions support Claude models
- Some features may differ from direct API
- Additional latency from routing

## Troubleshooting

- "Permission denied" - Check IAM roles
- "API not enabled" - Enable required APIs
- "Quota exceeded" - Request quota increase

Consult Vertex AI documentation for details.