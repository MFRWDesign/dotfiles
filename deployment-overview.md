# Claude Code Deployment Overview

Claude Code can be deployed in multiple environments to suit different
organizational needs and security requirements. This guide provides an
overview of the available deployment options.

## Deployment Options

### Cloud Provider Integrations

1. **Amazon Bedrock** - Deploy through AWS with enterprise features
2. **Google Vertex AI** - Integrate with Google Cloud Platform

### Enterprise Deployment

For organizations with specific security requirements:

1. **Direct API Access** - Standard Anthropic API deployment
2. **Private Cloud** - Isolated deployment options

## Choosing a Deployment Method

Consider these factors when selecting your deployment approach:

- Security requirements
- Compliance needs
- Geographic restrictions
- Performance requirements
- Cost considerations

### Quick Comparison

| Method | Security | Complexity | Cost |
|--------|----------|------------|------|
| Direct API | Standard | Low | Pay-per-use |
| Bedrock | High | Medium | AWS pricing |
| Vertex AI | High | Medium | GCP pricing |

## Getting Started

Each deployment method has specific requirements:

1. **API Keys** - Required for all methods
2. **Cloud Accounts** - For Bedrock/Vertex
3. **Network Config** - For enterprise deployments

### Prerequisites

- Claude Code CLI installed
- Appropriate credentials
- Network access to chosen provider

## Security Considerations

All deployment methods support:
- Encrypted connections
- Access control
- Audit logging
- Data residency options

## Next Steps

Choose your deployment method and follow the specific guide:
- Amazon Bedrock Guide
- Google Vertex AI Guide
- Direct API Setup

For questions, consult the troubleshooting guide.