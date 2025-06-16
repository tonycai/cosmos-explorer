<div align="center">

![Ping Dashboard](./public/logo.svg)

<h1>Ping Dashboard</h1>

**A comprehensive Cosmos blockchain explorer, wallet, and DeFi hub 🚀**

[![version](https://img.shields.io/github/tag/ping-pub/explorer.svg)](https://github.com/ping-pub/explorer/releases/latest)
[![GitHub](https://img.shields.io/github/license/ping-pub/explorer.svg)](https://github.com/ping-pub/explorer/blob/master/LICENSE)
[![Twitter URL](https://img.shields.io/twitter/url/https/twitter.com/bukotsunikki.svg?style=social&label=Follow%20%40ping_pub)](https://twitter.com/ping_pub)
[![Discord](https://img.shields.io/badge/discord-join-7289DA.svg?logo=discord&longCache=true&style=flat)](https://discord.gg/CmjYVSr6GW)

</div>

---

## 🌟 Overview

**Ping Dashboard** is a next-generation blockchain explorer and wallet interface for the Cosmos ecosystem. Unlike traditional explorers that rely on cached data, Ping Dashboard provides real-time blockchain exploration by directly interfacing with Cosmos full nodes via LCD/RPC endpoints - earning it the distinction as a **"Light Explorer"**.

**🔗 Live App:** [https://ping.pub](https://ping.pub)

**🧪 Current Configuration**: This instance is configured for **AIW3 Devnet** with integrated faucet functionality and CORS-enabled API proxy.

---

## ✨ Key Features

### 🔍 **Blockchain Explorer**
- **Real-time Data**: Direct LCD/RPC integration without caching
- **Multi-chain Support**: Configurable for Cosmos-based blockchains
- **Block & Transaction Analysis**: Detailed inspection tools
- **Validator Information**: Complete validator metrics and performance data
- **Network Statistics**: Live network health and metrics

### 💼 **Integrated Wallet**
- **Multi-wallet Support**: Keplr, Unisat, and more
- **Portfolio Management**: Asset tracking across multiple chains
- **Transaction Broadcasting**: Direct transaction submission
- **Account Management**: Multiple account support

### 🏛️ **Governance & Staking**
- **Proposal Tracking**: Complete governance proposal lifecycle
- **Voting Interface**: Direct on-chain voting
- **Staking Operations**: Delegate, redelegate, and unbond
- **Rewards Management**: Claim and compound staking rewards

### 🌉 **Inter-Blockchain Communication (IBC)**
- **Cross-chain Transfers**: Seamless asset movement
- **IBC Channel Monitoring**: Real-time channel status
- **Relayer Information**: Complete relayer network data

### 🚰 **Integrated Faucet**
- **Testnet Token Distribution**: Built-in faucet functionality
- **Direct Faucet Integration**: Supports both ping.pub and custom faucet services
- **Balance Monitoring**: Faucet account balance tracking
- **Transaction Confirmation**: Direct transaction links
- **Rate Limiting**: Built-in protection against abuse

### 🎨 **Advanced Features**
- **NFT Support**: View and manage Cosmos NFTs
- **CosmWasm Integration**: Smart contract interaction
- **State Sync**: Fast node synchronization tools
- **Custom Widgets**: Embeddable blockchain widgets
- **CORS Proxy**: Built-in proxy for API endpoints without CORS support

---

## 🏗️ Architecture

### **Technology Stack**
- **Frontend**: Vue 3 + TypeScript + Vite
- **Styling**: TailwindCSS + DaisyUI
- **State Management**: Pinia
- **Blockchain Integration**: CosmJS + Osmosis.js
- **Build Tool**: Vite with modern ES modules
- **Deployment**: Docker + Nginx
- **Proxy**: Vite dev server proxy for CORS handling

### **Project Structure**
```
src/
├── components/     # Reusable UI components
├── layouts/        # Application layouts
├── modules/        # Feature modules
│   ├── [chain]/   # Chain-specific features
│   │   └── faucet/ # Faucet functionality
│   └── wallet/    # Wallet functionality
├── pages/         # Route pages
├── plugins/       # Vue plugins (i18n, etc.)
├── router/        # Vue Router configuration
├── stores/        # Pinia state stores
│   └── useDashboard.ts # Main dashboard store
└── types/         # TypeScript definitions

chains/
└── testnet/       # Testnet configurations (default)
    └── aiw3-devnet.json  # AIW3 devnet config

docker/
├── Dockerfile         # Production build
├── Dockerfile.dev     # Development build
├── docker-compose.yml # Container orchestration
├── nginx.conf        # Web server configuration
└── docker.sh         # Management script
```

---

## 🚀 Getting Started

### **Prerequisites**
- **Node.js**: v16+ (recommended: latest LTS)
- **Yarn**: v1.22+ or npm v8+
- **Docker**: v20+ (for containerized deployment)
- **Git**: For cloning the repository

### **Quick Setup (Docker - Recommended)**

1. **Clone the repository**
   ```bash
   git clone https://github.com/ping-pub/explorer.git
   cd explorer
   ```

2. **Start with Docker (Production)**
   ```bash
   # Build and start production server
   ./docker.sh build
   ./docker.sh start
   
   # Access at: http://localhost:8080
   ```

3. **Start with Docker (Development)**
   ```bash
   # Start development server with hot reload
   ./docker.sh dev
   
   # Access at: http://localhost:3000
   ```

### **Manual Setup (Traditional)**

1. **Install dependencies**
   ```bash
   yarn install --ignore-engines
   ```

2. **Start development server**
   ```bash
   yarn dev
   ```

3. **Access the application**
   - Open [http://localhost:3000](http://localhost:3000)
   - For testnet: Use a hostname containing "testnet" (e.g., `testnet.localhost:3000`)

---

## 🐳 Docker Deployment

### **Available Commands**
```bash
./docker.sh build      # Build production image
./docker.sh dev        # Start development server
./docker.sh start      # Start production server
./docker.sh stop       # Stop all containers
./docker.sh restart    # Restart production
./docker.sh logs       # View container logs
./docker.sh clean      # Remove containers/images
./docker.sh help       # Show help
```

### **Production Deployment**
```bash
# Build the production image
./docker.sh build

# Start production server
./docker.sh start

# Monitor logs
./docker.sh logs

# Health check
curl http://localhost:8080/health
```

### **Development Environment**
```bash
# Start development with hot reload
./docker.sh dev

# View development logs
./docker.sh logs
```

### **Docker Compose Services**
- **ping-dashboard**: Production service (port 8080)
- **ping-dashboard-dev**: Development service (port 3000)

### **Production Build**

```bash
# Manual build for production
yarn build

# Preview production build
yarn preview

# Deploy to web server
cp -r ./dist/* /path/to/web/server/root
```

---

## 🌐 AIW3 Devnet Configuration

### **Current Setup**
This Ping Dashboard instance is configured for the **AIW3 Devnet** with the following services:

**Network Details**:
- **Chain ID**: `aiw3-devnet`
- **Token**: AIW3 (6 decimal places)
- **Address Prefix**: `aiw3`
- **Coin Type**: 118
- **Network Type**: Testnet (default)

**Service Endpoints**:
- **API Service**: `https://devnet-api.aiw3.io` (proxied via `http://localhost:3000/api`)
- **RPC Service**: `https://devnet-rpc.aiw3.io`
- **Faucet Service**: `https://devnet-faucet.aiw3.io`

### **Configuration File**
```json
{
    "chain_name": "aiw3-devnet",
    "api": ["http://localhost:3000/api"],
    "rpc": ["https://devnet-rpc.aiw3.io"],
    "faucet": "https://devnet-faucet.aiw3.io",
    "sdk_version": "0.47.1",
    "coin_type": "118",
    "min_tx_fee": "1000",
    "addr_prefix": "aiw3",
    "logo": "https://mypinata.moonpump.ai/ipfs/bafybeie7kjiokeo7pm5j33tszrouvntmw3i3tiu4q7ddv4qewddwsrfud4",
    "theme_color": "#4338ca",
    "assets": [{
        "base": "uaiw3",
        "symbol": "AIW3",
        "exponent": "6",
        "coingecko_id": "",
        "logo": ""
    }]
}
```

### **CORS Proxy Configuration**
The Vite development server includes a proxy configuration to handle CORS issues:

```typescript
// vite.config.ts
server: {
  proxy: {
    '/api': {
      target: 'https://devnet-api.aiw3.io',
      changeOrigin: true,
      rewrite: (path) => path.replace(/^\/api/, ''),
      configure: (proxy, _options) => {
        proxy.on('error', (err, _req, _res) => {
          console.log('proxy error', err);
        });
        proxy.on('proxyReq', (proxyReq, req, _res) => {
          console.log('Sending Request to the Target:', req.method, req.url);
        });
        proxy.on('proxyRes', (proxyRes, req, _res) => {
          console.log('Received Response from the Target:', proxyRes.statusCode, req.url);
        });
      },
    },
  },
}
```

---

## 🚰 Faucet Server

### **Accessing the Faucet**
The integrated faucet allows users to request testnet tokens for development and testing.

**Faucet URL**: Visit `/aiw3-devnet/faucet` in the application

### **How to Use**
1. **Navigate to Faucet**: Go to `http://localhost:3000/aiw3-devnet/faucet`
2. **Enter Address**: Paste your AIW3 address (starts with `aiw3`)
3. **Request Tokens**: Click "Get Tokens" to receive testnet funds
4. **Transaction Confirmation**: View the transaction hash for confirmation

### **Faucet Features**
- ✅ **Real-time Balance**: Shows current faucet account balance
- ✅ **Transaction Tracking**: Direct links to successful transactions
- ✅ **Address Validation**: Ensures proper address format
- ✅ **Status Monitoring**: Health checks for faucet availability
- ✅ **Direct Integration**: Works with custom faucet services
- ✅ **Automatic Configuration**: Detects faucet type and adjusts accordingly

### **Faucet Configuration**
The faucet component automatically detects the faucet type:

**For Custom Faucets (like AIW3)**:
- Uses the `faucet` URL directly from chain configuration
- Handles custom API responses
- Shows configured faucet address and balance

**For Ping.pub Central Service**:
- Falls back to `https://faucet.ping.pub/{chain_name}`
- Uses standard ping.pub faucet API format

### **Current Faucet Status**
- **Faucet Address**: `aiw31r5v5srda7xfth3hn2s26txvrcrntldjur3whgk`
- **Balance**: ~50,000 AIW3 tokens
- **Amount per Request**: 1 AIW3 token
- **Status**: ✅ Fully Operational

---

## 🔧 Custom Upgrade Guide

### **For Future Chain Upgrades**

This section provides a comprehensive guide for upgrading to new chains or updating existing configurations.

#### **1. Adding a New Chain**

**Step 1: Create Chain Configuration**
```bash
# Create new chain config file
touch chains/testnet/your-new-chain.json
```

**Step 2: Configure Chain Details**
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

**Step 3: Handle CORS Issues**
If your API doesn't support CORS, update `vite.config.ts`:

```typescript
server: {
  proxy: {
    '/api': {
      target: 'https://api.your-chain.com',
      changeOrigin: true,
      rewrite: (path) => path.replace(/^\/api/, ''),
    },
  },
}
```

Then update your chain config to use the proxy:
```json
{
    "api": ["http://localhost:3000/api"]
}
```

#### **2. Updating Existing Chain**

**Step 1: Update Configuration**
```bash
# Edit existing configuration
nano chains/testnet/aiw3-devnet.json
```

**Step 2: Update Endpoints**
- Update API, RPC, and faucet URLs
- Modify SDK version if needed
- Update token information

**Step 3: Test Configuration**
```bash
# Restart development server
./docker.sh stop
./docker.sh dev

# Test endpoints
curl -s http://localhost:3000/api/cosmos/base/tendermint/v1beta1/node_info
```

#### **3. Network Type Configuration**

**Default to Testnet** (current setup):
```typescript
// src/stores/useDashboard.ts
async loadingFromLocal() {
  // Default to testnet to enable faucet access
  this.networkType = NetworkType.Testnet;
  // Override only if explicitly on a mainnet hostname
  if(window.location.hostname.search("mainnet") > -1) {
    this.networkType = NetworkType.Mainnet
  }
  // ... rest of the code
}
```

**Default to Mainnet**:
```typescript
async loadingFromLocal() {
  // Default to mainnet
  this.networkType = NetworkType.Mainnet;
  // Override if hostname contains "testnet"
  if(window.location.hostname.search("testnet") > -1) {
    this.networkType = NetworkType.Testnet
  }
  // ... rest of the code
}
```

#### **4. Faucet Integration**

**For Custom Faucet Services**:
1. Set the `faucet` field in chain configuration to your faucet URL
2. The faucet component will automatically use the custom service
3. Update faucet address and balance in the component if needed

**For Ping.pub Central Service**:
1. Remove or set `faucet` field to empty string
2. The component will fallback to `https://faucet.ping.pub/{chain_name}`

#### **5. Docker Deployment Updates**

**Update Production Build**:
```bash
# Stop current containers
./docker.sh stop

# Rebuild with new configuration
./docker.sh build --no-cache

# Start updated service
./docker.sh start
```

**Update Development Environment**:
```bash
# Restart development server
./docker.sh stop
./docker.sh dev
```

#### **6. Testing Checklist**

Before deploying upgrades, test the following:

**Basic Functionality**:
- [ ] Chain loads correctly
- [ ] API endpoints respond
- [ ] Block explorer shows latest blocks
- [ ] Transaction search works

**Wallet Integration**:
- [ ] Connect wallet (Keplr/Unisat)
- [ ] Address displays correctly
- [ ] Balance shows properly
- [ ] Send transactions work

**Advanced Features**:
- [ ] Staking operations (delegate/undelegate)
- [ ] Governance proposals display
- [ ] IBC transfers (if applicable)
- [ ] Faucet functionality

**Performance**:
- [ ] Page load times acceptable
- [ ] Real-time updates working
- [ ] No console errors
- [ ] Mobile responsiveness

#### **7. Troubleshooting Common Issues**

**CORS Errors**:
- Add proxy configuration to `vite.config.ts`
- Update chain config to use proxy URL
- Ensure target API supports the required endpoints

**Faucet Not Working**:
- Check faucet URL in chain configuration
- Verify faucet service is operational
- Update faucet component logic if needed

**Chain Not Loading**:
- Verify JSON syntax in chain configuration
- Check network type (mainnet vs testnet)
- Ensure all required fields are present

**Docker Issues**:
- Clear Docker cache: `./docker.sh clean`
- Rebuild without cache: `./docker.sh build --no-cache`
- Check container logs: `./docker.sh logs`

---

## ⚙️ Configuration

### **Adding New Blockchains**

1. **Create configuration file**
   ```bash
   # For testnet (current setup)
   touch chains/testnet/your-chain.json
   ```

2. **Configuration format**
   ```json
   {
     "chain_name": "your-chain",
     "api": ["https://api.your-chain.com"],
     "rpc": ["https://rpc.your-chain.com"],
    "faucet": "https://faucet.your-chain.com",
    "sdk_version": "0.47.0",
    "coin_type": "118",
    "min_tx_fee": "1000",
    "addr_prefix": "yourchain",
    "assets": [{
      "base": "uyourtoken",
      "symbol": "YOURTOKEN",
      "exponent": "6"
    }]
   }
   ```

### **LCD/RPC Endpoint Setup**

Your blockchain nodes must have LCD API enabled:

```toml
# In config/app.toml
[api]
enable = true
swagger = false
address = "tcp://0.0.0.0:1317"
max-open-connections = 1000
```

**CORS Configuration** (nginx example):
```nginx
server {
    server_name api.your-chain.com;
    listen 443 ssl;
    
    location / {
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Max-Age 3600;
        add_header Access-Control-Expose-Headers Content-Length;
        proxy_pass http://localhost:1317;
    }
}
```

---

## 📱 Usage

### **Explorer Features**
- **Block Explorer**: Browse blocks and transactions
- **Validator Information**: View validator details and performance
- **Network Statistics**: Monitor network health and metrics
- **Search**: Find blocks, transactions, and addresses

### **Wallet Integration**
- **Connect Wallet**: Support for Keplr and other Cosmos wallets
- **Send Transactions**: Transfer tokens directly from the interface
- **Staking Operations**: Delegate, redelegate, and claim rewards
- **Portfolio View**: Track balances across multiple accounts

### **Faucet Usage**
- **Get Test Tokens**: Use the integrated faucet for development
- **Address Validation**: Automatic validation of wallet addresses
- **Transaction Confirmation**: Direct links to successful transactions

### **Development Features**
- **Real-time Updates**: Live blockchain data without caching
- **API Integration**: Direct connection to blockchain nodes
- **Custom Widgets**: Embeddable components for other applications

---

## 🛠️ Development

### **Available Scripts**
```bash
# Traditional development
yarn dev          # Start development server
yarn build        # Build for production
yarn preview      # Preview production build
yarn type-check   # Run TypeScript checks

# Docker development
./docker.sh dev   # Start development with Docker
./docker.sh build # Build production image
./docker.sh start # Start production container
```

### **Code Style**
- **ESLint**: For code linting
- **Prettier**: For code formatting
- **TypeScript**: For type safety

### **Adding New Features**

1. **Create feature module**: `src/modules/your-feature/`
2. **Add routes**: Vue Router will auto-discover `.vue` files
3. **Create stores**: Use Pinia for state management
4. **Add types**: Define TypeScript interfaces in `src/types/`

### **Testing Checklist**
When contributing, please test:
- [ ] Connect wallet and verify address
- [ ] Transfer tokens
- [ ] Delegate to validator
- [ ] Redelegate between validators
- [ ] Unbond delegation
- [ ] Withdraw validator commission
- [ ] Withdraw staking rewards
- [ ] Faucet functionality
- [ ] Docker deployment

---

## 🤝 Contributing

We welcome contributions! Please follow these guidelines:

### **Code Contributions**
1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

### **Adding New Chains**
1. Create configuration file in `chains/testnet/`
2. Test all functionality with the testing checklist
3. Submit PR with configuration and test results

### **Issue Reporting**
- Use GitHub Issues for bug reports
- Provide detailed reproduction steps
- Include browser and OS information
- Mention Docker environment if applicable

---

## 💰 Support the Project

### **Donations**
Your support helps us build better tools for the Cosmos ecosystem:

**ERC20 Address** (USDC, USDT, ETH):
```
0x88BFec573Dd3E4b7d2E6BfD4D0D6B11F843F8aa1
```

### **Sponsors**
Special thanks to our sponsors:
- **Point Network**: $1000 USDC + $1000 worth of POINT
- **BitSong**: 50,000 BTSG  
- **IRISnet**: 100,000 IRIS

### **Hire Our Team**
Fund development through [IssueHunter](https://issuehunt.io/r/ping-pub/explorer)

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👥 Core Team

- **@liangping** - Lead Developer
- **@dingyiming** - Core Developer

---

## 🔗 Links

- **Website**: [https://ping.pub](https://ping.pub)
- **Discord**: [Join our community](https://discord.gg/CmjYVSr6GW)
- **Twitter**: [@ping_pub](https://twitter.com/ping_pub)
- **GitHub**: [ping-pub/explorer](https://github.com/ping-pub/explorer)

---

<div align="center">

**Built with ❤️ for the Cosmos ecosystem**

*Empowering users to explore, interact, and transact across the interchain*

**🧪 AIW3 Devnet Explorer - Ready for Development & Testing**

</div>

