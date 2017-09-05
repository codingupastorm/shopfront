var MerchantHub = artifacts.require("./MerchantHub.sol");

module.exports = function(deployer) {
  deployer.deploy(MerchantHub);
};
