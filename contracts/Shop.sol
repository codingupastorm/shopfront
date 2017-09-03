pragma solidity ^0.4.2;

import "./Owned.sol";

contract Shop is Owned {

	struct Product{
		uint256 id;
		uint256 price;
		uint256 stock;
	}

	mapping (uint256 => Product) public products;

	LogProductAdded(uint256 id indexed, uint256 price, uint256 stock);
	LogWithdrawal(uint256 amount);
	LogPayment(address to indexed, uint256 amount);
	LogProductBought(address buyer indexed, uint256 id indexed);

	// admin actions

	function addProduct(uint256 id, uint256 price, uint256 stock)
	onlyOwner
	returns (bool) {
		require(id > 0 && products[id].id == 0);
		require(price > 0);
		require(stock > 0);
		products[id] = Product(id, price, stock);
		LogProductAdded(id, price, stock);
		return true;
	}

	function withdraw(uint256 amount)
	onlyOwner
	returns (bool) {
		require(amount < this.balance && amount > 0);
		msg.sender.transfer(amount);
		LogWithdrawal(amount);
		return true;
	}

	function pay(address to, uint256 amount)
	onlyOwner
	returns (bool) {
		require(amount < this.balance && amount > 0);
		to.transfer(amount);
		LogPayment(to, amount);
		return true;
	}

	// user actions

	function buyProduct(uint256 id)
	payable
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
