pragma solidity ^0.5.0;

contract Escrow {
    enum State { AWAITING_LOTTERY, COMPLETE }
    enum LotteryState { OPEN, DRAW, DRAWN, COMPLETE }
    struct Cheque {
        address payable _from;
        uint amount;
        State currentState;
    }
    LotteryState public lst;
    address payable public organization;
    address payable public winner;
    mapping(uint=>Cheque) public cheques;
    uint public cheque_count;
    modifier onlyOrg() {
        require(msg.sender == organization,"Only organization can call this method");
        _;
    }

    constructor(address payable _organization) public {
        cheque_count = 0;
        organization = _organization;
    }

    function escrowBalance() public view returns (uint) {
        return address(this).balance;
    }

    function addParticipant(address payable participant_id, uint amount) external payable returns (bool success) {
        require(lst == LotteryState.OPEN,"Participation for this round is closed");
        cheque_count++;
        cheques[cheque_count] = Cheque(participant_id, amount, State.AWAITING_LOTTERY);
        return true;
    }
    function allocateWinner(address payable winner_id) private {
        require(lst == LotteryState.DRAW,"Lottery is not in draw state");
        winner = winner_id;
        lst = LotteryState.DRAWN;
    }

    function pay_winner() external payable onlyOrg {
        require(lst == LotteryState.DRAWN,"Lottery is not in correct state");
        require(address(this).balance > 2,"Payment is already made");
        
        // winner ID is algorithmically calculated here 
        allocateWinner(msg.sender);     // change msg.sender to something else here
        // pay the lottery fees to organization ( optional to be removed in case of decentralized automated auction)
        organization.transfer(2);
        // pay the winner it's reward
        winner.transfer(address(this).balance);
        for(uint x=1;x<=cheque_count;x++) {
            if(cheques[x].currentState == State.AWAITING_LOTTERY) {
                cheques[x].currentState = State.COMPLETE;
            }
        }
        lst = LotteryState.COMPLETE;
    }

}