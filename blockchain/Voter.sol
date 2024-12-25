// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Voter{
      mapping (address=> bool) public  hasVoted;
      mapping (address=> address)  public candidateVoted;
    address private owner;
    constructor( address _owner){
        owner= _owner;     //  when a contract deploys another contract the sender becomes the parent contract therefore wee nedd to asssign owner as the person who does the  transaction;
    }

    function getVoteDetail(address election ) public view returns (bool){
        return hasVoted[election];
    }

    function voteDone(address election ) public returns (bool){
        hasVoted[election]= true;   
        return true;
    }
    function setCandidateVote(address candidate,address election) public {
        candidateVoted[candidate]= election;
    }
    function getOwner() public view returns (address){
        return owner;
    }



}