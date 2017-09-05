pragma solidity ^0.4.6;

import "./Merchant.sol";
import "./Owned.sol";

contract MerchantHub is Owned {
  address[] public merchants;
  mapping(address => bool) public merchantExists;

  function createMerchant()
  public
  returns (address) {
    require(msg.sender != address(0));
    Merchant trustedMerchant = new Merchant(msg.sender);
    merchants.push(trustedMerchant);
    merchantExists[trustedMerchant] = true;
    return merch;
  }

  function switchOnOffMerchant(address merchant, bool onOff)
  public
  onlyOwner
  returns (bool) {
    require(merchantExists[merchant]);
    Merchant trustedMerchant = Merchant(merchant);
    trustedMerchant.switchActive(onOff);
    return true;
  }

  function takeCut()
  public
  payable
  returns (bool){
    require(merchantExists[msg.sender]);
    return true;
  }

  function withdraw(uint256 amount)
  onlyOwner
  public
  returns (bool) {
    require(amount < this.balance && amount > 0);
    msg.sender.transfer(amount);
    return true;
  }

}
