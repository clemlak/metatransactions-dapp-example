/* eslint-env node */
/* global artifacts */

const MetaDapp = artifacts.require('MetaDapp');

function deployContracts(deployer) {
  deployer.deploy(MetaDapp);
}

module.exports = deployContracts;
