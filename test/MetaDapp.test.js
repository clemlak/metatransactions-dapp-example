/* eslint-env node, mocha */
/* global artifacts, contract, it, assert */

const MetaDapp = artifacts.require('MetaDapp');

let instance;

contract('MetaDapp', (accounts) => {
  it('Should deploy an instance of the MetaDapp contract', () => MetaDapp.deployed()
    .then((contractInstance) => {
      instance = contractInstance;
    }));

  it('Should set the number', () => instance.setNumber(2, {
    from: accounts[0],
  }));

  it('Should get the number', () => instance.getNumber()
    .then((number) => {
      assert.equal(number.toNumber(), 2, 'Number is wrong!');
    }));
});
