pragma solidity ^0.4.6;

import "./Owned.sol";

contract OwnedPayable is Owned {
  function()
  onlyOwner
  payable {
  }
}
