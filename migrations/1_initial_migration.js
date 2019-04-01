const Migrations = artifacts.require("Migrations");
const Betting = artifacts.require("Betting");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(Betting);
};
