// const ethers= require("hardhat");
require("@nomicfoundation/hardhat-toolbox");
async function main() {
  // const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  // const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
  // const unlockTime = currentTimestampInSeconds + ONE_YEAR_IN_SECS;

  // const lockedAmount = hre.ethers.utils.parseEther("1");

  const auction = await ethers.getContractFactory("NFTAuction");
  const Auction = await auction.deploy();

  await Auction.deployed();


  console.log("Contract address",
    Auction.address
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
