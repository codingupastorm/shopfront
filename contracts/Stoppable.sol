pragma solidity ^0.4.6;

import "./Owned.sol";

contract Stoppable is Owned {
  bool public active;

  function Stoppable(){
    active = true;
  }

  modifier mustBeActive {
    require(active);
    _;
  }

  function switchActive(bool isActive)
  public
  onlyOwner {
    active = isActive;
  }
}
