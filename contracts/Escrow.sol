pragma solidity ^0.5.0;

contract Escrow {
    enum State {OPEN, CLOSED, DONE}

    State public currentState;

    mapping(uint=>address payable) public buyer;
    uint buyer_count;
    address payable public winner;
    address payable public arbiter;

    modifier buyerOnly(){
        bool condition = false;
        for(uint x=1;x<=buyer_count;x++){
            if(msg.sender == buyer[x]){
                condition = true;
            }
        }
        require(condition || msg.sender == arbiter,"Not permissioned to make function call");
        _;
    }

    modifier winnerOnly(){
        require(msg.sender == arbiter || msg.sender == winner,"Not permissioned to make function call");
        _;
    }

    modifier arbiterOnly() {
        require(msg.sender == arbiter,"Exclusive access required");
        _;
    }

    modifier inState(State expectedState){
        require(currentState == expectedState);
        _;
    }

    constructor(address payable _arbiter) public{
        winner = _arbiter;
        arbiter = _arbiter;
    }

    function participate(address payable buy_ad) public inState(State.OPEN){
        buyer_count++;
        buyer[buyer_count] = buy_ad;
    }

    function decideWinner() private inState(State.CLOSED){
        // logic to decide winner here 
        winner = arbiter;
    }

    function draw() public payable arbiterOnly inState(State.CLOSED){
        // decide the winner 

        // check if the balance has more than 2 coins
        arbiter.transfer(2);
        winner.transfer(address(this).balance);
        currentState = State.DONE;
    }

    function reset() public arbiterOnly inState(State.DONE){
        // make the current state as the done state
        buyer_count = 0;
        
    }

    function currentStakes() public view returns(uint){
        return address(this).balance;
    }

}