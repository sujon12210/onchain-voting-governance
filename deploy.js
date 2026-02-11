const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  
  // Replace with an existing ERC20 address or a deployed mock
  const TOKEN_ADDRESS = "0x5FbDB2315678afecb367f032d93F642f64180aa3"; 
  const QUORUM = hre.ethers.parseEther("1000"); // 1000 tokens

  const gov = await hre.ethers.deployContract("Governance", [TOKEN_ADDRESS, QUORUM]);
  await gov.waitForDeployment();

  console.log("Governance deployed to:", await gov.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
