// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "./Token.sol";

contract dBank {

  Token private token;
  mapping(address => uint) public etherBalanceOf;
  mapping(address => uint) public depositStart;
  mapping(address => bool) public isDeposited;


event Deposit(address indexed user, uint etherAmount, uint timeStart);
event Withdraw(address indexed user, uint amount, uint heldTime, uint interest);

  constructor(Token _token) public {
    token = _token;
  }

  function deposit() payable public {
  require(!isDeposited[msg.sender]);
  require(msg.value >= .01 ether);

  etherBalanceOf[msg.sender] += msg.value;
  depositStart[msg.sender] = depositStart[msg.sender] + block.timestamp;
  isDeposited[msg.sender] = true;

  emit Deposit(msg.sender, msg.value, block.timestamp);
  }

  function withdraw() public {
    require(isDeposited[msg.sender]);
    uint etherDeposit = etherBalanceOf[msg.sender];

    uint holdTime = block.timestamp - depositStart[msg.sender];

    uint interestPerSecond = 31668017 * (etherBalanceOf[msg.sender] / 1e16);
    uint interest = interestPerSecond * holdTime;

    etherBalanceOf[msg.sender] = 0;
    depositStart[msg.sender] = 0;
    isDeposited[msg.sender] = false;

    msg.sender.transfer(etherDeposit);
    //use mint function to mint tokens based on how much interest has accrued over time 
    token.mint(msg.sender, interest);

    emit Withdraw(msg.sender, etherDeposit, holdTime, interest);

  

  }

  function borrow() payable public {
    
  }

  function payOff() public {
   
  }
}
