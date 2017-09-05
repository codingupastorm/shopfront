var MerchantHub = artifacts.require('./MerchantHub.sol');
const Promise = require('bluebird');
Promise.promisifyAll(web3.eth, {suffix: "Promise"});


contract('MerchantHub', function(accounts) {
  var merchantHub;

  beforeEach("deploy a MerchantHub", function() {
    return MerchantHub.new({from: accounts[0]}).then(_hub => merchantHub = _hub);
  });

  it("should deploy a Merchant", function(){
    return merchantHub.createMerchant({from: accounts[0]})
      .then(result => console.log(result));
  });
  // it("should save ether between two accounts", function() {
  //   const toSplit = 1000;
  //   const afterSplit = 500;
  //   return splitter.split(bob, carol, {
  //     from: alice,
  //     value: toSplit
  //   }).then(result => splitter.balances.call(bob)).then(bobBalance => assert.equal(bobBalance, afterSplit)).then(() => splitter.balances.call(carol)).then(carolBalance => assert.equal(carolBalance, afterSplit));
  // });
  //
  // it("should split odd amount correctly", function() {
  //   const toSplit = 3;
  //   const afterSplit = 1;
  //   return splitter.split(bob, carol, {
  //     from: alice,
  //     value: toSplit
  //   }).then(result => splitter.balances.call(bob)).then(bobBalance => assert.equal(bobBalance, afterSplit)).then(() => splitter.balances.call(carol)).then(carolBalance => assert.equal(carolBalance, afterSplit)).then(() => splitter.balances.call(alice)).then(aliceBalance => assert.equal(aliceBalance, 1));
  // });
  //
  // it("should withdraw correctly", function() {
  //   const toSplit = 1000;
  //   const afterSplit = 500;
  //   const gasPrice = 10;
  //   var bobStartBalance,
  //     cost;
  //   return web3.eth.getBalancePromise(bob).then((bobBalance) => {
  //     bobStartBalance = bobBalance.toNumber();
  //     return splitter.split(bob, carol, {
  //       from: alice,
  //       value: toSplit
  //     });
  //   }).then(result => splitter.claim({from: bob, gasPrice: gasPrice})).then(tx => {
  //     cost = gasPrice * tx.receipt.gasUsed;
  //     return web3.eth.getBalancePromise(bob);
  //   }).then(bobFinalBalance => {
  //     assert.equal(bobStartBalance + afterSplit - cost, bobFinalBalance.toNumber());
  //   });
  // });

  it('should fail on amount too small', function() {
    const toSplit = 1;
    return expectedExceptionPromise(function(){
      return splitter.split(bob, carol, {from: alice,value: toSplit, gas: 3000000});
    }, 3000000);
  });

  // it("should fail on empty address", function() {
  //   const toSplit = 1000;
  //   return splitter.split(bob, "0x0", {
  //     from: alice,
  //     value: toSplit
  //   }).then(result => assert.fail("Should have thrown error.")).catch(() => assert(true)); // Again, need to check for out of gas error
  // });

});
