// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {GeneralBallot} from "./GeneralBallot.sol";
 interface IBallot  {
    function init(uint) external;
     error VoteInputLength();
    error IncorrectCredits();
    error OwnerPermissioned();

    // Eg 3 candidates A,B,C contest , then if i want to vote C in general ballot my voteArr will be [0,0,1] and if i want to rank them in ranked & irv as B > C >A . [1,2,0]

    function vote(uint[] memory) external;
}

interface IResultCalculator  {
    error NoWinner();
    error NoCandidates();
    error CandidatesTie();
    error VotesExhausted();
    function getResults(
        bytes calldata returnData,
        uint _resultType
    ) external returns (uint[] memory);
}


contract Election is Initializable{
     error AlreadyVoted();
    address private owner ; 
    uint256 totalVotes ; 
    struct Candidate{
        uint256 candidateId ;
        string name ;
        string  description;
    }

    uint256 public  winner ; 
    bool ballotInitialized;
    Candidate[] public candidates; 
    IResultCalculator resultCalculator;
    mapping (address => bool voted) userVoted; 
    GeneralBallot private ballot ;
    function initialize(
        Candidate[] memory  _candidates,
        address _owner , 
        address _ballotAddress

    ) external initializer{
         for(uint256 i = 0 ;i< _candidates.length;i++){ // add _candidates to candidates array 
            candidates.push(
                Candidate(
                    i,
                    _candidates[i].name,
                    _candidates[i].description
                )
            );
        }
        owner    =  _owner;
        ballot = GeneralBallot(_ballotAddress);
        totalVotes = 0;
    }
     function userVote(uint[] memory voteArr) external  {
        if (userVoted[msg.sender]) revert AlreadyVoted();
        if (ballotInitialized == false) {
            ballot.init(candidates.length);
            ballotInitialized = true;
        }
        ballot.vote(voteArr);
        userVoted[msg.sender] = true;
        totalVotes++;
    }
    function addCandidate(
        string calldata _name,
        string calldata _description
    ) external   {
        Candidate memory newCandidate = Candidate(
            candidates.length,
            _name,
            _description
        );
        candidates.push(newCandidate);
    }
    
    function removeCandidate(uint _id) external {
        candidates[_id] = candidates[candidates.length - 1]; // Replace with last element
    candidates.pop(); 
}
    function calculateResult() public {
     
        GeneralBallot general =  GeneralBallot(address(ballot));
         winner  = general.getWinner();
    }

    


}