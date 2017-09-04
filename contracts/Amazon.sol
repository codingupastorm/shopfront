pragma solidity ^0.4.6;

import "./Merchant.sol";

contract Amazon {
  address[] merchants public;
  mapping(uint256 => address) productToMerchant public;

  //for end users
  function buyProduct(uint256 id) {
    productToMerchant[id].buyProduct(id);
  }

  //for merchants - from merchant contract
  function addProduct(uint256 id)
  public
  returns (bool) {
    productToMerchant[id] = msg.sender;
    return true;
  }

  function createMerchant()
  public
  returns (address) {
    Merchant merch = new Merchant(msg.sender);
    merchants.push(merch);
    return merch;
  }

  function removeMerchant()
  public
  onlyOwner
  returns (bool) {

  }

  function takeCut()
  public
  payable{
  }

}
