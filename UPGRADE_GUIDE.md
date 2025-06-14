# 🔧 Ping Dashboard Custom Upgrade Guide

This guide provides step-by-step instructions for upgrading and customizing Ping Dashboard for new blockchain networks.

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Quick Upgrade Checklist](#quick-upgrade-checklist)
3. [Adding New Chains](#adding-new-chains)
4. [Updating Existing Chains](#updating-existing-chains)
5. [CORS Configuration](#cors-configuration)
6. [Faucet Integration](#faucet-integration)
7. [Network Type Configuration](#network-type-configuration)
8. [Docker Deployment](#docker-deployment)
9. [Testing & Validation](#testing--validation)
10. [Troubleshooting](#troubleshooting)
11. [Best Practices](#best-practices)

---

## Prerequisites

Before starting any upgrade, ensure you have:

- **Node.js**: v16+ (recommended: latest LTS)
- **Docker**: v20+ (for containerized deployment)
- **Git**: For version control
- **Access to blockchain endpoints**: API, RPC, and optionally faucet
- **Basic knowledge**: JSON configuration, Docker commands

---

## Quick Upgrade Checklist

Use this checklist for rapid upgrades:

### Pre-Upgrade
- [ ] Backup current configuration files
- [ ] Document current working endpoints
- [ ] Stop running containers: `./docker.sh stop`
- [ ] Test new endpoints manually

### Configuration
- [ ] Create/update chain configuration file
- [ ] Configure CORS proxy if needed
- [ ] Update faucet integration
- [ ] Set network type (mainnet/testnet)

### Deployment
- [ ] Build new Docker image: `./docker.sh build --no-cache`
- [ ] Start development server: `./docker.sh dev`
- [ ] Run full test suite
- [ ] Deploy to production: `./docker.sh start`

### Post-Upgrade
- [ ] Verify all functionality works
- [ ] Monitor logs for errors
- [ ] Update documentation
- [ ] Commit changes to version control

---

## Adding New Chains

### Step 1: Create Chain Configuration

```bash
# For testnet chains (recommended for development)
touch chains/testnet/your-new-chain.json

# For mainnet chains
touch chains/mainnet/your-new-chain.json
```

### Step 2: Basic Configuration Template

```json
{
    "chain_name": "your-new-chain",
    "api": ["https://api.your-chain.com"],
    "rpc": ["https://rpc.your-chain.com"],
    "faucet": "https://faucet.your-chain.com",
    "sdk_version": "0.47.1",
    "coin_type": "118",
    "min_tx_fee": "1000",
    "addr_prefix": "yourchain",
    "logo": "https://your-logo-url.com/logo.png",
    "theme_color": "#your-brand-color",
    "assets": [{
        "base": "uyourtoken",
        "symbol": "YOURTOKEN",
        "exponent": "6",
        "coingecko_id": "your-token-coingecko-id",
        "logo": "https://your-token-logo.com/logo.png"
    }]
}
```

### Step 3: Advanced Configuration Options

```json
{
    "chain_name": "advanced-chain",
    "api": [
        {
            "address": "https://api1.your-chain.com",
            "provider": "Provider 1"
        },
        {
            "address": "https://api2.your-chain.com", 
            "provider": "Provider 2"
        }
    ],
    "rpc": [
        {
            "address": "https://rpc1.your-chain.com:26657",
            "provider": "Provider 1"
        }
    ],
    "faucet": {
        "amount": "1000000",
        "ip_limit": 10,
        "address_limit": 5,
        "fees": "1000"
    },
    "sdk_version": "0.47.1",
    "coin_type": "118",
    "min_tx_fee": "1000",
    "addr_prefix": "advanced",
    "consensus_prefix": "advancedvalcons",
    "logo": "https://your-logo.com/logo.svg",
    "theme_color": "#4338ca",
    "features": ["stargate", "ibc-transfer", "cosmwasm"],
    "keplr_features": ["stargate", "ibc-transfer"],
    "keplr_price_step": {
        "low": 0.01,
        "average": 0.025,
        "high": 0.04
    },
    "assets": [{
        "base": "uadvanced",
        "symbol": "ADVANCED",
        "exponent": "6",
        "coingecko_id": "advanced-token",
        "logo": "https://your-token-logo.com/logo.png"
    }]
}
```

---

## Updating Existing Chains

### Step 1: Backup Current Configuration

```bash
# Create backup
cp chains/testnet/aiw3-devnet.json chains/testnet/aiw3-devnet.json.backup

# Or backup entire chains directory
cp -r chains chains_backup_$(date +%Y%m%d_%H%M%S)
```

### Step 2: Update Configuration

```bash
# Edit configuration file
nano chains/testnet/aiw3-devnet.json

# Or use your preferred editor
code chains/testnet/aiw3-devnet.json
```

### Step 3: Common Updates

**Update Endpoints:**
```json
{
    "api": ["https://new-api.your-chain.com"],
    "rpc": ["https://new-rpc.your-chain.com"],
    "faucet": "https://new-faucet.your-chain.com"
}
```

**Update Token Information:**
```json
{
    "assets": [{
        "base": "unewtoken",
        "symbol": "NEWTOKEN",
        "exponent": "6",
        "coingecko_id": "new-token-id",
        "logo": "https://new-logo.com/logo.png"
    }]
}
```

**Update SDK Version:**
```json
{
    "sdk_version": "0.47.2"
}
```

---

## CORS Configuration

Many blockchain APIs don't support CORS, which prevents browser access. Here's how to handle this:

### Method 1: Vite Proxy (Development)

Update `vite.config.ts`:

```typescript
export default defineConfig({
  // ... existing config
  server: {
    proxy: {
      '/api': {
        target: 'https://your-api-endpoint.com',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api/, ''),
        configure: (proxy, _options) => {
          proxy.on('error', (err, _req, _res) => {
            console.log('Proxy error:', err);
          });
          proxy.on('proxyReq', (proxyReq, req, _res) => {
            console.log('Proxying request:', req.method, req.url);
          });
          proxy.on('proxyRes', (proxyRes, req, _res) => {
            console.log('Proxy response:', proxyRes.statusCode, req.url);
          });
        },
      },
    },
  },
});
```

Then update your chain configuration:
```json
{
    "api": ["http://localhost:3000/api"]
}
```

### Method 2: Nginx Proxy (Production)

Update `nginx.conf`:

```nginx
server {
    listen 80;
    server_name localhost;

    # Existing configuration...

    # Add API proxy
    location /api/ {
        proxy_pass https://your-api-endpoint.com/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # CORS headers
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Allow-Methods "GET, POST, OPTIONS";
        add_header Access-Control-Allow-Headers "DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range";
        add_header Access-Control-Expose-Headers "Content-Length,Content-Range";
    }
}
```

---

## Faucet Integration

### Custom Faucet Service

For chains with their own faucet service (like AIW3):

```json
{
    "faucet": "https://your-faucet-service.com"
}
```

The faucet component will automatically:
- Use the custom faucet URL
- Handle custom API responses
- Display appropriate faucet information

### Ping.pub Central Service

For chains using the central ping.pub faucet:

```json
{
    "faucet": ""
}
```

Or omit the faucet field entirely. The component will fallback to:
`https://faucet.ping.pub/{chain_name}`

### Advanced Faucet Configuration

```json
{
    "faucet": {
        "amount": "1000000",
        "ip_limit": 10,
        "address_limit": 5,
        "fees": "1000"
    }
}
```

### Custom Faucet Component Updates

If you need to customize faucet behavior, edit `src/modules/[chain]/faucet/index.vue`:

```typescript
// Update balance function for custom faucet APIs
function balance() {
    if (typeof chainStore.current?.faucet === 'string') {
        // Custom faucet logic
        faucet.value = 'your-faucet-address';
        balances.value = [{ denom: 'uyourtoken', amount: 'balance-amount' }];
        return;
    }
    
    // Default ping.pub faucet logic
    // ... existing code
}
```

---

## Network Type Configuration

### Default to Testnet (Current Setup)

Edit `src/stores/useDashboard.ts`:

```typescript
async loadingFromLocal() {
    // Default to testnet to enable faucet access
    this.networkType = NetworkType.Testnet;
    // Override only if explicitly on a mainnet hostname
    if(window.location.hostname.search("mainnet") > -1) {
        this.networkType = NetworkType.Mainnet
    }
    // ... rest of configuration loading
}
```

### Default to Mainnet

```typescript
async loadingFromLocal() {
    // Default to mainnet
    this.networkType = NetworkType.Mainnet;
    // Override if hostname contains "testnet"
    if(window.location.hostname.search("testnet") > -1) {
        this.networkType = NetworkType.Testnet
    }
    // ... rest of configuration loading
}
```

### Hostname-based Network Detection

```typescript
async loadingFromLocal() {
    // Detect network based on hostname patterns
    const hostname = window.location.hostname;
    
    if (hostname.includes('testnet') || hostname.includes('dev')) {
        this.networkType = NetworkType.Testnet;
    } else if (hostname.includes('mainnet') || hostname.includes('main')) {
        this.networkType = NetworkType.Mainnet;
    } else {
        // Default behavior
        this.networkType = NetworkType.Testnet; // or Mainnet
    }
    
    // ... rest of configuration loading
}
```

---

## Docker Deployment

### Development Deployment

```bash
# Stop existing containers
./docker.sh stop

# Start development server with hot reload
./docker.sh dev

# Monitor logs
./docker.sh logs
```

### Production Deployment

```bash
# Stop existing containers
./docker.sh stop

# Build production image (with cache clearing if needed)
./docker.sh build --no-cache

# Start production server
./docker.sh start

# Verify deployment
curl -I http://localhost:8080
```

### Docker Compose Override

For custom configurations, create `docker-compose.override.yml`:

```yaml
version: '3.8'

services:
  ping-dashboard-dev:
    environment:
      - CUSTOM_VAR=value
    ports:
      - "3001:3000"  # Use different port
    volumes:
      - ./custom-config:/app/custom-config
```

### Multi-Environment Setup

```bash
# Development
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up

# Staging
docker-compose -f docker-compose.yml -f docker-compose.staging.yml up

# Production
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up
```

---

## Testing & Validation

### Automated Testing Script

Create `test-upgrade.sh`:

```bash
#!/bin/bash

echo "🧪 Testing Ping Dashboard Upgrade..."

# Test API endpoints
echo "Testing API endpoint..."
API_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/api/cosmos/base/tendermint/v1beta1/node_info)
if [ "$API_RESPONSE" = "200" ]; then
    echo "✅ API endpoint working"
else
    echo "❌ API endpoint failed (HTTP $API_RESPONSE)"
    exit 1
fi

# Test faucet endpoint
echo "Testing faucet endpoint..."
FAUCET_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" https://your-faucet.com/balance)
if [ "$FAUCET_RESPONSE" = "200" ]; then
    echo "✅ Faucet endpoint working"
else
    echo "⚠️  Faucet endpoint not accessible (HTTP $FAUCET_RESPONSE)"
fi

# Test web interface
echo "Testing web interface..."
WEB_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000)
if [ "$WEB_RESPONSE" = "200" ]; then
    echo "✅ Web interface working"
else
    echo "❌ Web interface failed (HTTP $WEB_RESPONSE)"
    exit 1
fi

echo "🎉 All tests passed!"
```

### Manual Testing Checklist

**Basic Functionality:**
- [ ] Homepage loads without errors
- [ ] Chain selector shows your chain
- [ ] Latest blocks display correctly
- [ ] Transaction search works
- [ ] Validator list loads

**API Integration:**
- [ ] Node info endpoint responds
- [ ] Block data loads correctly
- [ ] Transaction details display
- [ ] Account balances show

**Wallet Integration:**
- [ ] Keplr wallet connects
- [ ] Address displays correctly
- [ ] Balance shows properly
- [ ] Transaction signing works

**Advanced Features:**
- [ ] Staking operations work
- [ ] Governance proposals display
- [ ] IBC transfers (if applicable)
- [ ] Faucet functionality

**Performance:**
- [ ] Page load times < 3 seconds
- [ ] Real-time updates working
- [ ] No console errors
- [ ] Mobile responsive

---

## Troubleshooting

### Common Issues and Solutions

#### 1. CORS Errors

**Symptoms:**
- Browser console shows CORS errors
- API requests fail with network errors
- "Access to fetch blocked by CORS policy" messages

**Solutions:**
```bash
# Add proxy configuration to vite.config.ts
# Update chain config to use proxy URL
# Verify target API supports required endpoints
```

#### 2. Chain Not Loading

**Symptoms:**
- Empty blockchain list
- "No chains found" message
- Configuration not detected

**Solutions:**
```bash
# Check JSON syntax
jsonlint chains/testnet/your-chain.json

# Verify network type configuration
# Ensure all required fields are present
# Check file permissions
ls -la chains/testnet/
```

#### 3. Faucet Not Working

**Symptoms:**
- Faucet page shows errors
- "Get Tokens" button disabled
- Balance not displaying

**Solutions:**
```bash
# Test faucet endpoint directly
curl -I https://your-faucet.com

# Check faucet URL in configuration
# Verify faucet service is operational
# Update faucet component if needed
```

#### 4. Docker Issues

**Symptoms:**
- Container won't start
- Build failures
- Port conflicts

**Solutions:**
```bash
# Clear Docker cache
./docker.sh clean

# Rebuild without cache
./docker.sh build --no-cache

# Check port availability
netstat -tulpn | grep :3000

# View detailed logs
docker-compose logs --tail=50 ping-dashboard-dev
```

#### 5. API Endpoint Issues

**Symptoms:**
- 404 errors on API calls
- Timeout errors
- Invalid response format

**Solutions:**
```bash
# Test endpoints manually
curl -s https://your-api.com/cosmos/base/tendermint/v1beta1/node_info

# Check endpoint format
# Verify SSL certificates
# Test with different endpoints
```

### Debug Mode

Enable debug logging by setting environment variables:

```bash
# In docker-compose.yml
environment:
  - DEBUG=true
  - LOG_LEVEL=debug
```

### Log Analysis

```bash
# View all logs
./docker.sh logs

# Follow logs in real-time
./docker.sh logs -f

# Filter specific errors
./docker.sh logs | grep ERROR

# Export logs for analysis
./docker.sh logs > debug_$(date +%Y%m%d_%H%M%S).log
```

---

## Best Practices

### 1. Configuration Management

- **Version Control**: Always commit configuration changes
- **Backup**: Keep backups of working configurations
- **Documentation**: Document all custom changes
- **Testing**: Test configurations in development first

### 2. Security

- **HTTPS**: Always use HTTPS endpoints in production
- **API Keys**: Never commit API keys to version control
- **CORS**: Configure CORS properly for security
- **Updates**: Keep dependencies updated

### 3. Performance

- **Caching**: Implement appropriate caching strategies
- **CDN**: Use CDN for static assets
- **Monitoring**: Monitor API response times
- **Optimization**: Optimize Docker images

### 4. Maintenance

- **Regular Updates**: Keep blockchain endpoints updated
- **Health Checks**: Implement health monitoring
- **Backup Strategy**: Regular configuration backups
- **Documentation**: Keep upgrade documentation current

### 5. Development Workflow

```bash
# 1. Create feature branch
git checkout -b upgrade/new-chain

# 2. Make configuration changes
# Edit chain configs, update code

# 3. Test locally
./docker.sh dev

# 4. Run test suite
./test-upgrade.sh

# 5. Commit changes
git add .
git commit -m "Add new chain configuration"

# 6. Deploy to staging
./docker.sh build
./docker.sh start

# 7. Final testing and merge
git checkout main
git merge upgrade/new-chain
```

---

## Support and Resources

### Documentation
- [Main README](./README.md)
- [Installation Guide](./installation.md)
- [Chain Configuration](./chains/README.md)

### Community
- **Discord**: [Join our community](https://discord.gg/CmjYVSr6GW)
- **GitHub Issues**: [Report bugs](https://github.com/ping-pub/explorer/issues)
- **Twitter**: [@ping_pub](https://twitter.com/ping_pub)

### Professional Support
- **Custom Development**: Available through [IssueHunter](https://issuehunt.io/r/ping-pub/explorer)
- **Consulting**: Contact the core team for enterprise support

---

*This guide is maintained by the Ping Dashboard community. Please contribute improvements and report issues.* 