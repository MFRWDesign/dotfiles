# Corporate Proxy Configuration

Configure Claude Code to work within corporate proxy environments.

## Proxy Support

Claude Code supports standard proxy environment variables:

```bash
export HTTP_PROXY=http://proxy.company.com:8080
export HTTPS_PROXY=http://proxy.company.com:8080
export NO_PROXY=localhost,127.0.0.1
```

## Authentication

For authenticated proxies:

```bash
export HTTP_PROXY=http://username:password@proxy.company.com:8080
```

## Certificate Issues

For self-signed certificates:

```bash
export NODE_TLS_REJECT_UNAUTHORIZED=0  # Use with caution
```

Better approach - add corporate CA:

```bash
export NODE_EXTRA_CA_CERTS=/path/to/corporate-ca.crt
```

## Troubleshooting

- Test proxy connectivity first
- Verify credentials are URL-encoded
- Check firewall rules for AI endpoints