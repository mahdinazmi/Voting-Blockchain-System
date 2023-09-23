// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Voting {
    struct Candidate {
       string name;
       uint256 voteCount;
    }
    
    // candidates list
    Candidate[] public candidates;

    // adress address owner who will be the owner of the smart contract 
    address owner;

    // which address has already voted
    // we have a boole either true or false 
    // that this man or this
    // this person has already voted so we are
    mapping(address => bool) public voters;
    
    // start time of voting
    uint256 public votingStart;

    // end of time voting
    uint256 public votingEnd;
    
    // _durationInMinutes ==> amount of time we want to keep this voting open
    constructor(string[] memory _candidateNames, uint256 _durationInMinutes) {
      for (uint256 i = 0; i < _candidateNames.length; i++) {
        candidates.push(Candidate({
            name: _candidateNames[i],
            voteCount: 0
        }));
      }
     owner = msg.sender;
     votingStart = block.timestamp;
     votingEnd = block.timestamp + (_durationInMinutes * 1 minutes);
   }

    //it means that only owner can run this
    modifier onlyOwner {
       require(msg.sender == owner);
       _;
    }

    function addCandidate(string memory _name) public onlyOwner {
        candidates.push(Candidate({
                name: _name,
                voteCount: 0
        }));
    }
    
    // we are first checking if the voter has already voted or not
    // if the candidate index is right and then we are going to increase the vote count by one
    // we are setting voters of message dot sender is equals to true 
    // it means that once the voter has already voted he or she cannot vote again

    function vote(uint256 _candidateIndex) public {
       require(!voters[msg.sender], "You have already voted.");
       require(_candidateIndex < candidates.length, "Invalid candidate index.");

       candidates[_candidateIndex].voteCount++;
       voters[msg.sender] = true;
    }

    function getAllVotesOfCandiates() public view returns (Candidate[] memory){
       return candidates;
    }

    function getVotingStatus() public view returns (bool) {
    return (block.timestamp >= votingStart && block.timestamp < votingEnd);
    }

    function getRemainingTime() public view returns (uint256) {
        require(block.timestamp >= votingStart, "Voting has not started yet.");
        if (block.timestamp >= votingEnd) {
            return 0;
        }
        return votingEnd - block.timestamp;
     }


}