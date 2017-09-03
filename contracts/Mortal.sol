pragma solidity ^0.4.6;

import "./Owned.sol";

contract Mortal is Owned {
  function kill()
  onlyOwner
  public {
    selfdestruct(msg.sender);
  }
}
