#!/bin/bash

# 🧪 Ping Dashboard Upgrade Testing Script
# This script validates the functionality after upgrades

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DEV_URL="http://localhost:3000"
PROD_URL="http://localhost:8080"
API_ENDPOINT="$DEV_URL/api"
FAUCET_URL="https://devnet-faucet.aiw3.io"

echo -e "${BLUE}🧪 Ping Dashboard Upgrade Testing Script${NC}"
echo "=================================================="

# Function to print status
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ $2${NC}"
    else
        echo -e "${RED}❌ $2${NC}"
        return 1
    fi
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Test 1: Check if development server is running
echo ""
echo "1. Testing Development Server..."
DEV_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$DEV_URL" 2>/dev/null || echo "000")
if [ "$DEV_RESPONSE" = "200" ]; then
    print_status 0 "Development server is running"
    SERVER_URL="$DEV_URL"
else
    print_warning "Development server not accessible (HTTP $DEV_RESPONSE)"
    
    # Check production server
    echo "   Checking production server..."
    PROD_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$PROD_URL" 2>/dev/null || echo "000")
    if [ "$PROD_RESPONSE" = "200" ]; then
        print_status 0 "Production server is running"
        SERVER_URL="$PROD_URL"
        API_ENDPOINT="$PROD_URL/api"
    else
        print_status 1 "No server is accessible"
        exit 1
    fi
fi

# Test 2: API Endpoint Health
echo ""
echo "2. Testing API Endpoints..."
API_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$API_ENDPOINT/cosmos/base/tendermint/v1beta1/node_info" 2>/dev/null || echo "000")
print_status $([ "$API_RESPONSE" = "200" ] && echo 0 || echo 1) "API endpoint health (HTTP $API_RESPONSE)"

if [ "$API_RESPONSE" = "200" ]; then
    # Get chain info
    CHAIN_INFO=$(curl -s "$API_ENDPOINT/cosmos/base/tendermint/v1beta1/node_info" 2>/dev/null)
    CHAIN_ID=$(echo "$CHAIN_INFO" | grep -o '"network":"[^"]*"' | cut -d'"' -f4 2>/dev/null || echo "unknown")
    print_info "Connected to chain: $CHAIN_ID"
fi

# Test 3: Latest Block
echo ""
echo "3. Testing Block Data..."
BLOCK_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$API_ENDPOINT/cosmos/base/tendermint/v1beta1/blocks/latest" 2>/dev/null || echo "000")
print_status $([ "$BLOCK_RESPONSE" = "200" ] && echo 0 || echo 1) "Latest block endpoint (HTTP $BLOCK_RESPONSE)"

if [ "$BLOCK_RESPONSE" = "200" ]; then
    BLOCK_INFO=$(curl -s "$API_ENDPOINT/cosmos/base/tendermint/v1beta1/blocks/latest" 2>/dev/null)
    BLOCK_HEIGHT=$(echo "$BLOCK_INFO" | grep -o '"height":"[^"]*"' | cut -d'"' -f4 2>/dev/null || echo "unknown")
    print_info "Current block height: $BLOCK_HEIGHT"
fi

# Test 4: Faucet Endpoint
echo ""
echo "4. Testing Faucet Service..."
FAUCET_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$FAUCET_URL" 2>/dev/null || echo "000")
if [ "$FAUCET_RESPONSE" = "200" ] || [ "$FAUCET_RESPONSE" = "404" ]; then
    print_status 0 "Faucet service is accessible (HTTP $FAUCET_RESPONSE)"
else
    print_warning "Faucet service not accessible (HTTP $FAUCET_RESPONSE)"
fi

# Test 5: Web Interface Components
echo ""
echo "5. Testing Web Interface..."

# Check if main page loads
MAIN_PAGE=$(curl -s "$SERVER_URL" 2>/dev/null || echo "")
if echo "$MAIN_PAGE" | grep -q "Ping Dashboard" || echo "$MAIN_PAGE" | grep -q "vue"; then
    print_status 0 "Main page loads correctly"
else
    print_status 1 "Main page content issue"
fi

# Test 6: Chain Configuration
echo ""
echo "6. Testing Chain Configuration..."

# Check if chain config is accessible
CONFIG_TEST=$(curl -s "$SERVER_URL" 2>/dev/null | grep -o "aiw3-devnet" | head -1 || echo "")
if [ -n "$CONFIG_TEST" ]; then
    print_status 0 "Chain configuration detected"
else
    print_warning "Chain configuration not detected in page"
fi

# Test 7: Docker Container Status
echo ""
echo "7. Testing Docker Environment..."

if command -v docker &> /dev/null; then
    # Check if containers are running
    DEV_CONTAINER=$(docker ps --filter "name=ping-dashboard-dev" --format "{{.Names}}" 2>/dev/null || echo "")
    PROD_CONTAINER=$(docker ps --filter "name=ping-dashboard" --format "{{.Names}}" 2>/dev/null || echo "")
    
    if [ -n "$DEV_CONTAINER" ]; then
        print_status 0 "Development container is running: $DEV_CONTAINER"
    elif [ -n "$PROD_CONTAINER" ]; then
        print_status 0 "Production container is running: $PROD_CONTAINER"
    else
        print_warning "No Ping Dashboard containers are running"
    fi
else
    print_warning "Docker not available for container testing"
fi

# Test 8: Performance Check
echo ""
echo "8. Testing Performance..."

START_TIME=$(date +%s%N)
PERF_RESPONSE=$(curl -s -o /dev/null -w "%{time_total}" "$SERVER_URL" 2>/dev/null || echo "999")
END_TIME=$(date +%s%N)

# Convert to milliseconds
LOAD_TIME=$(echo "scale=0; $PERF_RESPONSE * 1000" | bc 2>/dev/null || echo "unknown")

if [ "$LOAD_TIME" != "unknown" ] && [ "$LOAD_TIME" -lt 3000 ]; then
    print_status 0 "Page load time: ${LOAD_TIME}ms (good)"
elif [ "$LOAD_TIME" != "unknown" ] && [ "$LOAD_TIME" -lt 5000 ]; then
    print_warning "Page load time: ${LOAD_TIME}ms (acceptable)"
else
    print_warning "Page load time: ${LOAD_TIME}ms (slow)"
fi

# Test 9: Configuration File Validation
echo ""
echo "9. Testing Configuration Files..."

CONFIG_FILE="chains/testnet/aiw3-devnet.json"
if [ -f "$CONFIG_FILE" ]; then
    if command -v jq &> /dev/null; then
        if jq empty "$CONFIG_FILE" 2>/dev/null; then
            print_status 0 "Chain configuration JSON is valid"
        else
            print_status 1 "Chain configuration JSON is invalid"
        fi
    else
        print_warning "jq not available for JSON validation"
    fi
    
    # Check required fields
    if grep -q '"chain_name"' "$CONFIG_FILE" && grep -q '"api"' "$CONFIG_FILE"; then
        print_status 0 "Required configuration fields present"
    else
        print_status 1 "Missing required configuration fields"
    fi
else
    print_status 1 "Chain configuration file not found"
fi

# Test 10: Network Connectivity
echo ""
echo "10. Testing External Network Connectivity..."

# Test external API
EXT_API_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "https://devnet-api.aiw3.io/cosmos/base/tendermint/v1beta1/node_info" 2>/dev/null || echo "000")
print_status $([ "$EXT_API_RESPONSE" = "200" ] && echo 0 || echo 1) "External API connectivity (HTTP $EXT_API_RESPONSE)"

# Test external RPC
EXT_RPC_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "https://devnet-rpc.aiw3.io/status" 2>/dev/null || echo "000")
print_status $([ "$EXT_RPC_RESPONSE" = "200" ] && echo 0 || echo 1) "External RPC connectivity (HTTP $EXT_RPC_RESPONSE)"

# Summary
echo ""
echo "=================================================="
echo -e "${BLUE}📊 Test Summary${NC}"
echo "=================================================="

# Count results (this is a simplified approach)
TOTAL_TESTS=10
echo "Total tests run: $TOTAL_TESTS"

# Check critical components
CRITICAL_PASSED=true

if [ "$API_RESPONSE" != "200" ]; then
    CRITICAL_PASSED=false
fi

if [ "$DEV_RESPONSE" != "200" ] && [ "$PROD_RESPONSE" != "200" ]; then
    CRITICAL_PASSED=false
fi

if [ "$CRITICAL_PASSED" = true ]; then
    echo -e "${GREEN}🎉 Critical tests passed! System is operational.${NC}"
    echo ""
    echo "✅ Web interface accessible"
    echo "✅ API endpoints responding"
    echo "✅ Chain connectivity established"
    echo ""
    echo -e "${BLUE}🚀 Ready for use at: $SERVER_URL${NC}"
    
    if [ "$SERVER_URL" = "$DEV_URL" ]; then
        echo -e "${BLUE}🚰 Faucet available at: $SERVER_URL/aiw3-devnet/faucet${NC}"
    fi
else
    echo -e "${RED}❌ Critical tests failed! System needs attention.${NC}"
    echo ""
    echo "Please check the failed tests above and resolve issues."
    exit 1
fi

echo ""
echo "=================================================="
echo -e "${BLUE}For detailed logs, run: ./docker.sh logs${NC}"
echo -e "${BLUE}For help, see: UPGRADE_GUIDE.md${NC}"
echo "==================================================" 