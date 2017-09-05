pragma solidity ^0.4.6;

import "./Merchant.sol";
import "./Owned.sol";

contract MerchantHub is Owned {
  address[] public merchants;
  mapping(address => bool) public merchantExists;

  event LogMerchantCreated(address indexed merchant, address indexed merchantOwner);
  event LogMerchantSwitched(address indexed merchant, bool onOff);
  event LogCutReceived(address indexed merchant, uint256 indexed amount);
  event LogWithdrawal(uint256 indexed amount);

  function createMerchant()
  public
  returns (address) {
    require(msg.sender != address(0));
    Merchant trustedMerchant = new Merchant(msg.sender);
    merchants.push(trustedMerchant);
    merchantExists[trustedMerchant] = true;
    LogMerchantCreated(trustedMerchant, msg.sender);
    return trustedMerchant;
  }

  function switchOnOffMerchant(address merchant, bool onOff)
  public
  onlyOwner
  returns (bool) {
    require(merchantExists[merchant]);
    Merchant trustedMerchant = Merchant(merchant);
    trustedMerchant.switchActive(onOff);
    LogMerchantSwitched(merchant, onOff);
    return true;
  }

  function takeCut()
  public
  payable
  returns (bool){
    require(merchantExists[msg.sender]);
    LogCutReceived(msg.sender, msg.value);
    return true;
  }

  function withdraw(uint256 amount)
  onlyOwner
  public
  returns (bool) {
    require(amount < this.balance && amount > 0);
    msg.sender.transfer(amount);
    LogWithdrawal(amount);
    return true;
  }
}
