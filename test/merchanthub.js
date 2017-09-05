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
      .then(receipt => {
        console.log(receipt);
      });
  });
});



function getTransactionReceiptMined(txHash, interval) {
  const transactionReceiptAsync = function(resolve, reject) {
    web3.eth.getTransactionReceipt(txHash, (error, receipt) => {
      if (error) {
        reject(error);
      } else if (receipt == null) {
        setTimeout(
          () => transactionReceiptAsync(resolve, reject),
          interval ? interval : 500);
      } else {
        resolve(receipt);
      }
    });
  };

  if (Array.isArray(txHash)) {
    return Promise.all(txHash.map(
      oneTxHash => getTransactionReceiptMined(oneTxHash, interval)));
  } else if (typeof txHash === "string") {
    return new Promise(transactionReceiptAsync);
  } else {
    throw new Error("Invalid Type: " + txHash);
  }
}
