// // SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
import "./Candidate.sol";
contract Election{
         Candidate[] public candidates;
   mapping (address => uint256)  electionResult;
   address[] cndidates;
   function addCandidate(Candidate c) public { 
      candidates.push(c);
   }
   function getLength() public view  returns(uint256){
      return candidates.length;
   }
   function getAddress( uint256 i) public view returns (address){
      return address(candidates[i]);
   }
   function setVote(address candidate) public {
      uint256 count = electionResult[candidate];
      count++;
      electionResult[candidate]= count;
   }
   function getMaxVote()public view returns (address,uint256) {
       uint votes=0 ;
       address candidate;
       for ( uint i=0 ;i< candidates.length;i++){
         if (electionResult[address(candidates[i])]>= votes){
            votes= electionResult[address(candidates[i])];
            candidate= address(candidates[i]);
         }

       }
       return (candidate , votes);
   }

}