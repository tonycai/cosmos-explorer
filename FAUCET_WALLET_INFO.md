# AIW3 Devnet Faucet Wallet Information

## Wallet Details

**Wallet Address**: `aiw31r5v5srda7xfth3hn2s26txvrcrntldjur3whgk`

**Mnemonic**: 
```
abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon art
```

**Private Key (Hex)**: 
```
8088c2ed2149c34f6d6533b774da4e1692eb5cb426fdbaef6898eeda489630b7
```

## Security Notice

⚠️ **IMPORTANT SECURITY INFORMATION**:
- This wallet contains testnet funds only
- Never use these credentials for mainnet operations
- This information is for development and testing purposes only
- Keep this file secure and do not share publicly in production environments

## Usage

This wallet is configured as the faucet server wallet in:
- `src/modules/[chain]/faucet/index.vue` (line 72)
- `README.md` (Current Faucet Status section)

## Network Information

- **Chain ID**: aiw3-devnet
- **Token**: AIW3 (uaiw3)
- **Decimals**: 6
- **Address Prefix**: aiw3
- **Coin Type**: 118

## Integration Status

✅ **Updated Components**:
- [x] Faucet component (`src/modules/[chain]/faucet/index.vue`)
- [x] README documentation
- [x] Wallet information documented

## Next Steps

1. Restart development server to apply changes
2. Test faucet functionality at `/aiw3-devnet/faucet`
3. Verify wallet address displays correctly
4. Ensure faucet distribution works properly

---
*Last Updated: $(date)*
*Configuration: AIW3 Devnet Testnet* 