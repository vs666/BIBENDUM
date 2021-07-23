pragma solidity ^0.5.0;

contract Escrow {

    struct Transaction {
        uint value;
        address payable from;
    }

    address payable public billingAddress;
    uint public ticket_amount;
    uint public ticket_price;
    mapping(uint=>Transaction) public participants;
    modifier onlyOwner(){
        require(msg.sender == billingAddress);
        _;
    }    

  constructor(address payable _billingAddress)public{
      billingAddress = _billingAddress;
      ticket_amount = 0;
      ticket_price = 2;
  }

  function getData(uint externalPaymentId) public view returns (address){
			require(externalPaymentId > 0 && externalPaymentId <= ticket_amount);
			return participants[externalPaymentId].from;
	}

  function getPrice()public view returns(uint){
      return address(this).balance;
	}

  // function startNewPayment(uint externalPaymentId, uint price) public onlyOwner{
		
  // }

  function pay()public payable{
      require(msg.value == ticket_price, "Amount is incorrect for buying 1 ticket");
      ticket_amount++;
      participants[ticket_amount].value = msg.value;
      participants[ticket_amount].from  = msg.sender;
  }

  // function complete(uint externalPaymentId)public onlyOwner{
  //     // called when payment is complete
  // }

  // function refund(uint externalPaymentId) public onlyOwner{
  //     // idk about this fs
  // }
}
