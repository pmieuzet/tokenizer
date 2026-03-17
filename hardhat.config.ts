import { HardhatUserConfig } from "hardhat/config";
import hardhatToolboxMochaEthersPlugin from "@nomicfoundation/hardhat-toolbox-mocha-ethers";

import * as dotenv from "dotenv";
dotenv.config();

const accounts = [
  process.env.PRIVATE_KEY,
  process.env.PRIVATE_KEY_MULTISIG,
].filter((key): key is string => !!key);

const config: HardhatUserConfig = {
  plugins: [hardhatToolboxMochaEthersPlugin],
  solidity: "0.8.28",
  paths: {
    sources: "./code/contracts",
    tests: "./code/test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  networks: {
    sepolia: {
      type: 'http',
      url: `https://eth-sepolia.g.alchemy.com/v2/${process.env.ALCHEMY_API_KEY}`,
      accounts: accounts.length > 0 ? accounts : []
    }
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
    customChains: [
      {
        network: "sepolia",
        chainId: 11155111,
        urls: {
          apiURL: "https://api-sepolia.etherscan.io/api",
          browserURL: "https://sepolia.etherscan.io/",
        }
      }
    ]
  },
};

export default config;
