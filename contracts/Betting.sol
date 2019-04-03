pragma solidity ^0.5.0;
contract Betting {
    
    struct Bets {
        string colorSelected; //TODO: Change to enum
        uint256 amountBet;
        address gambler;
    }
    
    
    event TimeOut(uint256 current_time); // have a listener that watches this event on javascript-side
    // given current_time so that there are no duplicates in timing out
    
    uint256 startTime; // time that betting rounds starts
    uint256 endTime; // time it ends
    uint256 minimumBet; // minimum buyin
    bool running; // whether or not there is a round currently ongoing

    mapping(bytes32 => Bets) public bets;
    
    constructor(uint256 _minimumBet) public {
        running = false; // shouldn't be started automatically
        minimumBet = _minimumBet; 
    }
    
    function winningColor(string memory _color) public { 
        // assumes the color is generated on the javascript-side
        // https://ethereum.stackexchange.com/questions/191/how-can-i-securely-generate-a-random-number-in-my-smart-contract
        // smart contracts are deterministic, so true randomness is difficult, but can be done if necessary
        endBet(_color);
    }

    function startBet(uint256 _endTime) public {
        // holds the start/end times and allows contract to start accepting transactions
        startTime = block.timestamp;
        endTime = block.timestamp + _endTime;
        running = true;
    }
    
    function checkTimeLeft() public returns (int256){
        // to be called from the javascript-side every second through setInterval
        // theoretically it SHOULDN'T require ether if called via using .call()
        // https://web3js.readthedocs.io/en/1.0/web3-eth.html#eth-call
        // ^ needs testing w/ front-end though
        if( int(endTime -block.timestamp) < 1){
            emit TimeOut(block.timestamp);
        }
        return int(endTime - block.timestamp);
    }
    
    function endBet(string memory _winningColor) public {
        // zero out all bet transactions
        running = false;
        // distribute funds for winning color
    }
   
    function makeBet(string memory _stringSelected ) public payable returns(bytes32) { // returning for testing purposes
        require(msg.value >= minimumBet, "did not meet minimum buy-in");
        require(running, "the bet is currently not running");
        require(checkTimeLeft() > 0, "time has run out");
        bytes32 betId = bytes32(keccak256(abi.encodePacked(block.timestamp, msg.sender)));
        bets[betId].colorSelected = _stringSelected;
        bets[betId].amountBet = msg.value;
        bets[betId].gambler = msg.sender;
        
    }
}