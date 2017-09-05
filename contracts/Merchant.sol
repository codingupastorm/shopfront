pragma solidity ^0.4.6;

import "./MerchantHub.sol";
import "./Stoppable.sol";

contract Merchant is Stoppable {

  struct Product{
    uint256 price;
    uint256 stock;
  }

  address public merchant;
  mapping (uint256 => Product) public products;

  modifier onlyMerchant {
    require(msg.sender == merchant);
    _;
  }

  function Merchant(address merchantAddress){
    merchant = merchantAddress;
  }

  event LogProductAdded(uint256 indexed id, uint256 price, uint256 stock);
  event LogProductRemoved(uint256 indexed id);
  event LogWithdrawal(uint256 amount);
  event LogPayment(address indexed to, uint256 amount);
  event LogProductBought(address indexed buyer, uint256 indexed id);

  function addProduct(uint256 id, uint256 price, uint256 stock)
  onlyMerchant
  public
  returns (bool) {
    require(id > 0 && products[id].price == 0); // id not used
    require(price > 0);
    require(stock > 0);
    products[id] = Product(price, stock);
    LogProductAdded(id, price, stock);
    return true;
  }

  function removeProduct(uint256 id)
  onlyMerchant
  public
  returns (bool){
    require(id > 0 && products[id].price != 0);
    products[id].price = 0;
    products[id].stock = 0;
    return true;
  }

  function withdraw(uint256 amount)
  onlyMerchant
  public
  returns (bool) {
    require(amount < this.balance && amount > 0);
    msg.sender.transfer(amount);
    LogWithdrawal(amount);
    return true;
  }

  function pay(address to, uint256 amount)
  onlyMerchant
  public
  returns (bool) {
    require(amount < this.balance && amount > 0);
    to.transfer(amount);
    LogPayment(to, amount);
    return true;
  }

  function buyProduct(uint256 id)
  payable
  public
  returns (bool) {
    require(products[id].stock > 0);
    require(msg.value >= products[id].price);
    products[id].stock--;
    MerchantHub trustedHub = MerchantHub(owner);
    trustedHub.takeCut.value(products[id].price / 10)();
    if (msg.value > products[id].price)
      msg.sender.transfer(msg.value - products[id].price); //give change
    LogProductBought(msg.sender, id);
    return true;
  }
}
