import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require("dotenv").config()


const config: HardhatUserConfig = {
  solidity: "0.8.17",
  // networks:{
  //   rinkeby:{
  //     // url: process.env.RINKBT_URL || "",
  //     // accounts: process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
  //     // accounts: process.env.PRIVATE_KEY === undefined ?  [process.env.PRIVATE_KEY]: ""
  //   }
  // }
};

export default config;
