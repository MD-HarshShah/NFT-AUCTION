require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config()

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.18",
  networks:{
    sepolia:{
      url:"https://sepolia.infura.io/v3/3b7605f98f494f3b93c16dd985ea8cc5",
      accounts: [process.env.PRIVATE_KEY]
    },
    // polygon_mumbai:{
      
    //   url : "https://polygon-mumbai.g.alchemy.com/v2/MkR__dwK2Sb9ozlP1t5WqtCNkp-8GyyN",
    //   accounts: [process.env.PRIVATE_KEY]
    // }
  }
};
