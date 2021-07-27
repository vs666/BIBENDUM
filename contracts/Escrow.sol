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

  function close() public onlyOwner{
      require(currentState == State.OPEN);
      currentState = State.CLOSED;
  }

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

    function reset() private {
        require(currentState == State.COMPLETED,'Lottery round not yet closed');
        // call function to close the lottery
        currentState = State.OPEN;
        ticket_amount = 0;
    }

    function getStatus() public view returns (string memory){
        if(currentState == State.OPEN){
            return "Open";
        }
        if(currentState == State.CLOSED){
            return "Closed";
        }
        if(currentState == State.COMPLETED){
            return "Completed";
        }
    }

    // testing remains
    function  generateHash(string memory _str) public view returns (uint) {
        uint random = uint(keccak256(abi.encodePacked(_str)));
        return (random%ticket_amount) + 1;
    }
    
    // testing remains
    function transferFunds() public payable {
        require(currentState == State.CLOSED,'Lottery round not yet closed');
        currentState = State.COMPLETED;
        string memory s1 = "";
        for(uint x=1;x<=ticket_amount;x++){
            s1 = string(abi.encodePacked(s1,participants[x].from));
        }
        uint nonce = 0;

        // relatively easy for now
        while(uint(keccak256(abi.encodePacked(s1,nonce)))> uint((1<<250))){
            nonce++;
        }
        uint winner_hash = generateHash(string(abi.encodePacked(s1,nonce)));

        winner = participants[winner_hash].from;
        winner.transfer(address(this).balance);
        reset();
    }

    function callWinner() public{
        winner = msg.sender;
    }

}
