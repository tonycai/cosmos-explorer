# 🚀 Ping Dashboard Installation Guide

This guide provides comprehensive installation instructions for Ping Dashboard, including both traditional and Docker-based deployments.

## 📋 Prerequisites

### Required Software

1. **Node.js and Yarn** - Acquired using Node Version Manager (recommended)
2. **Docker** - For containerized deployment (recommended)
3. **Git** - For cloning the repository

### Quick Install for Prerequisites

#### 1. Install Node Version Manager
```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
```

#### 2. Install the latest version of NodeJS
```sh
nvm install node # "node" is an alias for the latest version
```

#### 3. Install the latest version of NPM for Node
```sh
nvm install-latest-npm # get the latest supported npm version on the current node version
```

#### 4. Install Yarn
```sh
npm install --global yarn
```

#### 5. Install Docker (Optional but Recommended)
- **macOS**: Download Docker Desktop from [docker.com](https://www.docker.com/products/docker-desktop)
- **Ubuntu/Debian**: 
  ```sh
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
  ```
- **Windows**: Download Docker Desktop from [docker.com](https://www.docker.com/products/docker-desktop)

---

## 🐳 Docker Installation (Recommended)

Docker provides the easiest and most consistent deployment experience.

### 1. Clone the Repository
```sh
git clone https://github.com/ping-pub/explorer.git
cd explorer
```

### 2. Quick Start with Docker

#### Development Environment
```sh
# Start development server with hot reload
./docker.sh dev

# Access at: http://localhost:3000
```

#### Production Environment
```sh
# Build and start production server
./docker.sh build
./docker.sh start

# Access at: http://localhost:8080
```

### 3. Docker Management Commands

```sh
# Available commands
./docker.sh build      # Build production image
./docker.sh dev        # Start development server
./docker.sh start      # Start production server
./docker.sh stop       # Stop all containers
./docker.sh restart    # Restart production
./docker.sh logs       # View container logs
./docker.sh clean      # Remove containers/images
./docker.sh help       # Show help
```

### 4. Verify Installation

```sh
# Run automated tests
./test-upgrade.sh

# Or manually check
curl -I http://localhost:3000  # Development
curl -I http://localhost:8080  # Production
```

---

## 🛠️ Traditional Installation

For development or custom deployments without Docker.

### 1. Clone and Install Dependencies
```sh
git clone https://github.com/ping-pub/explorer.git
cd explorer
yarn install --ignore-engines
```

### 2. Development Server
```sh
# Start development server
yarn dev

# Access at: http://localhost:3000
```

### 3. Production Build
```sh
# Build for production
yarn build

# Preview production build
yarn preview

# Deploy to web server
cp -r ./dist/* /path/to/web/server/root
```

### 4. Available Scripts
```sh
yarn dev          # Start development server
yarn build        # Build for production
yarn preview      # Preview production build
yarn type-check   # Run TypeScript checks
yarn lint         # Run ESLint
```

---

## ⚙️ Configuration

### Network Type Configuration

The application determines which network to load based on configuration:

**Current Setup (Testnet Default)**:
- Loads from `chains/testnet/` directory by default
- Enables faucet functionality
- Suitable for development and testing

**To Change to Mainnet Default**:
Edit `src/stores/useDashboard.ts`:
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

### Chain Configuration

Add your blockchain configuration in the appropriate directory:

**For Testnet**:
```sh
touch chains/testnet/your-chain.json
```

**For Mainnet**:
```sh
touch chains/mainnet/your-chain.json
```

**Configuration Template**:
```json
{
    "chain_name": "your-chain",
    "api": ["https://api.your-chain.com"],
    "rpc": ["https://rpc.your-chain.com"],
    "faucet": "https://faucet.your-chain.com",
    "sdk_version": "0.47.1",
    "coin_type": "118",
    "min_tx_fee": "1000",
    "addr_prefix": "yourchain",
    "logo": "https://your-logo.com/logo.png",
    "theme_color": "#your-color",
    "assets": [{
        "base": "uyourtoken",
        "symbol": "YOURTOKEN",
        "exponent": "6",
        "coingecko_id": "your-token-id",
        "logo": "https://your-token-logo.com/logo.png"
    }]
}
```

---

## 🌐 Enable LCD for Your Chain

Configure your blockchain node to work with Ping Dashboard.

### 1. Enable LCD API

Set `enable = true` in `./config/app.toml`:

```toml
###############################################################################
###                           API Configuration                             ###
###############################################################################

[api]

# Enable defines if the API server should be enabled.
enable = true

# Swagger defines if swagger documentation should automatically be registered.
swagger = false

# Address defines the API server to listen on.
address = "tcp://0.0.0.0:1317"

# MaxOpenConnections defines the number of maximum open connections.
max-open-connections = 1000

# EnableUnsafeCORS defines if CORS should be enabled (unsafe - use it at your own risk).
enable-unsafe-cors = true
```

### 2. Configure CORS (Production)

Add proxy server and enable CORS. **Note: You must enable HTTPS as well.**

#### Nginx Configuration
```nginx
server {
    server_name your-api.your-chain.com;
    listen 443 ssl;
    
    # SSL configuration
    ssl_certificate /path/to/your/certificate.crt;
    ssl_certificate_key /path/to/your/private.key;
    
    location / {
        # CORS headers
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Allow-Methods "GET, POST, OPTIONS";
        add_header Access-Control-Allow-Headers "DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range";
        add_header Access-Control-Max-Age 3600;
        add_header Access-Control-Expose-Headers "Content-Length,Content-Range";

        # Handle preflight requests
        if ($request_method = 'OPTIONS') {
            add_header Access-Control-Allow-Origin *;
            add_header Access-Control-Allow-Methods "GET, POST, OPTIONS";
            add_header Access-Control-Allow-Headers "DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range";
            add_header Access-Control-Max-Age 1728000;
            add_header Content-Type 'text/plain; charset=utf-8';
            add_header Content-Length 0;
            return 204;
        }

        proxy_pass http://localhost:1317;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

#### Apache Configuration
```apache
<VirtualHost *:443>
    ServerName your-api.your-chain.com
    
    # SSL configuration
    SSLEngine on
    SSLCertificateFile /path/to/your/certificate.crt
    SSLCertificateKeyFile /path/to/your/private.key
    
    # CORS headers
    Header always set Access-Control-Allow-Origin "*"
    Header always set Access-Control-Allow-Methods "GET, POST, OPTIONS"
    Header always set Access-Control-Allow-Headers "DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range"
    Header always set Access-Control-Max-Age "3600"
    Header always set Access-Control-Expose-Headers "Content-Length,Content-Range"
    
    # Proxy configuration
    ProxyPreserveHost On
    ProxyPass / http://localhost:1317/
    ProxyPassReverse / http://localhost:1317/
</VirtualHost>
```

### 3. CORS Proxy for Development

If your API doesn't support CORS, configure a proxy in `vite.config.ts`:

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

---

## 🧪 Testing Your Installation

### Automated Testing

Run the comprehensive test suite:

```sh
# Make sure the test script is executable
chmod +x test-upgrade.sh

# Run all tests
./test-upgrade.sh
```

The test script will verify:
- ✅ Server accessibility
- ✅ API endpoint health
- ✅ Block data retrieval
- ✅ Faucet service (if configured)
- ✅ Web interface loading
- ✅ Chain configuration
- ✅ Docker container status
- ✅ Performance metrics
- ✅ Configuration file validation
- ✅ External network connectivity

### Manual Testing

**Basic Functionality**:
1. Open browser to `http://localhost:3000` (dev) or `http://localhost:8080` (prod)
2. Verify chain appears in the blockchain list
3. Check that latest blocks are displayed
4. Test transaction search functionality
5. Verify validator list loads

**API Testing**:
```sh
# Test node info
curl -s http://localhost:3000/api/cosmos/base/tendermint/v1beta1/node_info

# Test latest block
curl -s http://localhost:3000/api/cosmos/base/tendermint/v1beta1/blocks/latest

# Test account balance (replace with actual address)
curl -s http://localhost:3000/api/cosmos/bank/v1beta1/balances/your-address
```

**Faucet Testing** (if configured):
1. Navigate to `/your-chain/faucet`
2. Enter a valid address
3. Click "Get Tokens"
4. Verify transaction completion

---

## 🔧 Troubleshooting

### Common Issues

#### 1. CORS Errors
**Symptoms**: Browser console shows CORS policy errors
**Solution**: 
- Configure proxy in `vite.config.ts` for development
- Set up proper CORS headers on your API server
- Use the proxy configuration examples above

#### 2. Chain Not Loading
**Symptoms**: Empty blockchain list or configuration not detected
**Solution**:
- Check JSON syntax: `jq empty chains/testnet/your-chain.json`
- Verify network type configuration
- Ensure all required fields are present
- Check file permissions

#### 3. Docker Issues
**Symptoms**: Container won't start or build failures
**Solution**:
```sh
# Clear Docker cache
./docker.sh clean

# Rebuild without cache
./docker.sh build --no-cache

# Check logs
./docker.sh logs

# Verify port availability
netstat -tulpn | grep :3000
```

#### 4. API Endpoint Issues
**Symptoms**: 404 errors, timeouts, or invalid responses
**Solution**:
- Test endpoints manually with curl
- Verify SSL certificates
- Check firewall settings
- Ensure LCD API is enabled on your node

#### 5. Performance Issues
**Symptoms**: Slow loading times or timeouts
**Solution**:
- Check network connectivity
- Verify API server performance
- Consider using multiple API endpoints
- Monitor server resources

### Debug Mode

Enable detailed logging:

```sh
# For Docker development
export DEBUG=true
./docker.sh dev

# For traditional development
DEBUG=true yarn dev
```

### Getting Help

- **Documentation**: See [README.md](./README.md) and [UPGRADE_GUIDE.md](./UPGRADE_GUIDE.md)
- **Community**: Join our [Discord](https://discord.gg/CmjYVSr6GW)
- **Issues**: Report bugs on [GitHub](https://github.com/ping-pub/explorer/issues)
- **Professional Support**: Available through [IssueHunter](https://issuehunt.io/r/ping-pub/explorer)

---

## 🚀 Next Steps

After successful installation:

1. **Configure Your Chain**: Add your blockchain configuration
2. **Test Functionality**: Run the test suite and manual tests
3. **Deploy to Production**: Use Docker for production deployment
4. **Monitor Performance**: Set up monitoring and logging
5. **Keep Updated**: Regularly update dependencies and configurations

For advanced configuration and customization, see the [UPGRADE_GUIDE.md](./UPGRADE_GUIDE.md).

---

*This installation guide is maintained by the Ping Dashboard community. Please contribute improvements and report issues.*