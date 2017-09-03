pragma solidity ^0.4.2;

import "./OwnedPayable.sol";
import "./Mortal.sol";

contract Shop is OwnedPayable, Mortal {

	struct Product{
		uint256 price;
		uint256 stock;
	}

	mapping (uint256 => Product) public products;

	event LogProductAdded(uint256 indexed id, uint256 price, uint256 stock);
	event LogProductRemoved(uint256 indexed id);
	event LogWithdrawal(uint256 amount);
	event LogPayment(address indexed to, uint256 amount);
	event LogProductBought(address indexed buyer, uint256 indexed id);

	// admin actions

	function addProduct(uint256 id, uint256 price, uint256 stock)
	onlyOwner
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
	onlyOwner
	public
	returns (bool){
		require(id > 0 && products[id].price != 0);
		products[id].price = 0;
		products[id].stock = 0;
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

	function pay(address to, uint256 amount)
	onlyOwner
	public
	returns (bool) {
		require(amount < this.balance && amount > 0);
		to.transfer(amount);
		LogPayment(to, amount);
		return true;
	}

	// user actions

	function buyProduct(uint256 id)
	payable
	public
	returns (bool) {
		require(products[id].stock > 0);
		require(products[id].price >= msg.value);
		products[id].stock--;
		if (msg.value > products[id].price)
			msg.sender.transfer(msg.value - products[id].price); //give change
		LogProductBought(msg.sender, id);
		return true;
	}

}
