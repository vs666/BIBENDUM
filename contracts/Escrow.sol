pragma solidity ^0.5.0;

contract Escrow {

    struct Transaction {
        uint value;
        address payable from;
    }

    enum State {OPEN,CLOSED,COMPLETED}
    address payable public billingAddress;
    uint public ticket_amount;
    uint public ticket_price;
    address payable public winner;
    State public currentState;
    mapping(uint=>Transaction) public participants;
    modifier onlyOwner(){
        require(msg.sender == billingAddress);
        _;
    }    

  constructor(address payable _billingAddress)public{
      billingAddress = _billingAddress;
      ticket_amount = 0;
      ticket_price = 2000000000000000000;
      currentState = State.OPEN;
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

  function pay()public payable returns (address){
      require(currentState == State.OPEN,'Lottery round closed for entry');
      require(msg.value == ticket_price, "Amount is incorrect for buying 1 ticket");
      ticket_amount++;
      participants[ticket_amount].value = msg.value;
      participants[ticket_amount].from  = msg.sender;
      return participants[ticket_amount].from;
  }

    function decideWinner() private {
        require(currentState == State.CLOSED,'Lottery round not yet closed');
        // call function to close the lottery
        // random_generator type of thing
        winner = msg.sender;    // this is horseshit
    }

    function transferFunds() public payable {
        require(currentState == State.CLOSED,'Lottery round not yet closed');
        winner.transfer(address(this).balance);
        currentState = State.COMPLETED;
    }

    function callWinner() public{
        decideWinner();
        transferFunds();

    }


    
//   function complete(uint externalPaymentId)public onlyOwner{
//       // called when payment is complete
//   }

//   function refund(uint externalPaymentId) public onlyOwner{
//       // idk about this fs
//   }
}
