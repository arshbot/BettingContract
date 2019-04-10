pragma solidity ^0.5.0;
contract Betting {
    
    
    enum colorChoices {red, blue, green, yellow, purple, orange}
    
    struct Bets {
        colorChoices colorSelected; 
        uint256 amountBet;
        address payable gambler;
    }
    
    bytes32[] betIds = new bytes32[](10);
    
    event TimeOut(uint256 current_time); // have a listener that watches this event on javascript-side
    // probably show color
    // given current_time so that there are no duplicates in timing out
    
    event Color(uint256 color);
    
    uint256 poolAmount;
    uint256 startTime; // time that betting rounds starts
    uint256 endTime; // time it ends
    uint256 minimumBet; // minimum buyin
    bool running; // whether or not there is a round currently ongoing
    mapping(bytes32 => Bets) public bets;
    
    constructor(uint256 _minimumBet) public {
        running = false; // shouldn't be started automatically
        minimumBet = _minimumBet; 
        betIds.length = 0;
    }
    
    function startBet(uint256 _endTime) public {
        // holds the start/end times and allows contract to start accepting transactions
        startTime = block.timestamp;
        endTime = block.timestamp + _endTime;
        running = true;
    }
    
    function currentTime() public view returns (int256){
        return int(endTime - block.timestamp);
    }
    
    function checkTimeLeft() public returns (int256){
        // to be called from the javascript-side every second through setInterval
        // theoretically it SHOULDN'T require ether if called via using .call()
        // https://web3js.readthedocs.io/en/1.0/web3-eth.html#eth-call
        // ^ needs testing w/ front-end though
        int256 time = currentTime();
        if(time < 1){
            emit TimeOut(block.timestamp);
        }
        return int(endTime - block.timestamp);
    }
    
    function endBet() public {
        running = false; // stop accepting bets
        // get winning colorChoices
        colorChoices winningColor = colorChoices(winningColor());
        address payable[] memory winners = getWinners(uint256(winningColor));
        if(winners.length != 0){
            for(uint256 i=0; i< winners.length; i++){
                payWinnings(winners.length, winners[i]);
            }
        }
    }
    function getWinners(uint256 _winningColor) public view returns (address payable[] memory) {
        address payable[] memory winners = new address payable[](10);
        uint256 index = 0;
        bool duplicate = false;
        // add them to winner array if they are not already
        for(uint256 i=0; i<betIds.length; i++) {
            if(bets[betIds[i]].colorSelected == colorChoices(_winningColor)){
                for(uint256 j = 0; j < index; j++){
                    if(bets[betIds[i]].gambler == winners[j]){
                        duplicate = true;
                    }
                }
                if(!duplicate){
                    winners[index] = bets[betIds[i]].gambler;
                    index = index + 1;
                    duplicate = false;
                }
            }
        return winners;
       }
   }
   
   function payWinnings(uint256 amountOfWinners, address payable gambler) public payable {
       gambler.transfer(poolAmount / amountOfWinners);
   }
   
    function makeBet(uint256 _colorSelected ) public payable returns(bytes32) {
        require(msg.value >= minimumBet, "did not meet minimum buy-in");
        require(running, "the bet is currently not running");
        require(currentTime() > 0, "time has run out");
        bytes32 betId = keccak256(abi.encodePacked(block.timestamp, msg.sender)); // casting fucked it
        bets[betId].colorSelected = colorChoices(_colorSelected);
        bets[betId].amountBet = msg.value;
        bets[betId].gambler = msg.sender;
        betIds.push(betId);
        poolAmount = poolAmount + msg.value;
    }
    
    function winningColor() public returns (uint256) { 
        uint256 sum = sumOfIds();
        uint256 color = uint(keccak256(abi.encodePacked(sum)))%6;
        emit Color(color);
        return color;
    }
    
    function clearBetIds() public {
        betIds.length = 0;
    }
    
    function sumOfIds() public view returns (uint256){
        uint256 sum = 0;
        for (uint i=0; i<betIds.length; i++) {
            sum = sum + uint(betIds[i]);
        }
        return sum;
    }
    
   // for testing 
   // basic global variables
   
   function getBetId() public view returns (bytes32) {
       return betIds[betIds.length -1]; // returns latest bet made
       // getting the entire array might not be possible due to web3.js limitations
       // need more research into this though
   }
   function getBetIdLength() public view returns (uint256){
        return betIds.length;
   }
   function getStartTime() public view returns (uint256){
        return startTime;
   }
   function getEndTime() public view returns (uint256){
        return endTime;
   }
   function getMinimumBet() public view returns (uint256){
        return minimumBet;
   }
   function getIsRunning() public view returns (bool){
        return running;
   }
   function getPoolAmount() public view returns (uint256){
    return poolAmount;
   }
   
   // get specific info from betId's
   
   function getColorSelected(bytes32 id) public view returns (uint256){
        return uint(bets[id].colorSelected);
   }
   function getAmountBet(bytes32 id) public view returns (uint256){
        return bets[id].amountBet;
   }
   function getGambler(bytes32 id) public view returns (address payable){
        return bets[id].gambler;
   }
   function getGambler(bytes32 id) public view returns (){
        return bets[id].gambler;
   }
}
