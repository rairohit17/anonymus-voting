
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;
interface IBallot  {
    function init(uint) external;
     error VoteInputLength();
    error IncorrectCredits();
    error OwnerPermissioned();

    // Eg 3 candidates A,B,C contest , then if i want to vote C in general ballot my voteArr will be [0,0,1] and if i want to rank them in ranked & irv as B > C >A . [1,2,0]

    function vote(uint[] memory) external;
}


contract GeneralBallot is IBallot {
    error InvalidVoteArrayLength();
    error InvalidVoteDistribution();

    address public electionContract;

    uint private totalCandidate;
    uint[] public candidateVotes;

    

    constructor(address _electionAddress) {
        electionContract = _electionAddress;
    }

    function init(uint _totalCandidate) external  {
        totalCandidate = _totalCandidate;
        candidateVotes = new uint[](_totalCandidate);
    }

    //just a sigle vote in arr [1]
    function vote(uint256[] memory _votes) external  {
        if (_votes.length != 1) revert InvalidVoteArrayLength();
        checkValidVotes(_votes[0]);
        candidateVotes[_votes[0]]++;
    }

    function getVotes() external view  returns (uint256[] memory) {
        return candidateVotes;
    }

    function checkValidVotes(uint256 _vote) internal view {
        if (_vote >= totalCandidate) revert InvalidVoteDistribution();
    }

    function getVoteWinnerCount(
    ) internal view  returns (uint, uint) {
        uint maxVotes = 0;
        uint winnerCount = 0;
        uint candidatesLength = candidateVotes.length;
        // First pass: find the maximum number of votes and the count of candidates with that maximum
        for (uint i = 0; i < candidatesLength; i++) {
            uint votes = candidateVotes[i];
            if (votes > maxVotes) {
                maxVotes = votes;
                winnerCount = 1;
            } else if (votes == maxVotes) {
                winnerCount++;
            }
        }
        return (maxVotes, winnerCount);
    }
    function getWinner () external view returns(uint256 ){
        ( uint256 maxVotes, uint256 winnerCount) = getVoteWinnerCount(); 
        if (winnerCount > 0){
            for( uint256 i = 0 ; i< candidateVotes.length;i++){
                if ((candidateVotes[i] == maxVotes)){
                    return i;
                }
            }
        }
        return 0;
    }

}
