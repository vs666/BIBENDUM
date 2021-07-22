const Escrow = artifacts.require("Escrow.sol");

module.exports = function(deployer, network, accounts) {
    const userAccount = accounts[0];
    deployer.deploy(Escrow, userAccount);
};