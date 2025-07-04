# LLM Gateway Integration

Deploy Claude Code behind an LLM Gateway for centralized management.

## Overview

LLM Gateways provide:
- Centralized API management
- Usage tracking and limits
- Security policies
- Request routing

## Configuration

Point Claude Code to your gateway:

```bash
export ANTHROPIC_BASE_URL=https://gateway.company.com/v1
export ANTHROPIC_API_KEY=your-gateway-key
```

## Popular Gateways

### Portkey

```bash
export PORTKEY_API_KEY=your-key
export ANTHROPIC_BASE_URL=https://api.portkey.ai/v1/proxy
```

### Helicone

```bash
export HELICONE_API_KEY=your-key
export ANTHROPIC_BASE_URL=https://api.helicone.ai/v1
```

## Benefits

- Unified billing
- Request logging
- Rate limiting
- Failover support
- Usage analytics

## Considerations

- Additional latency
- Gateway availability
- Feature compatibility