// // SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

 import "./Election.sol";
 import "./Candidate.sol";
 import "./Voter.sol";
contract Interface {

    Voter[] public voters;

     function addVoter() public returns (address) {
        for (uint256 i = 0; i < voters.length; i++) {
            if (voters[i].getOwner() == msg.sender) {
             revert("voter already registered");
            }
}  
   // 0x070D2BCe3d224d318496cDF52b1ECA06cCceb171
   // 

        Voter v= new Voter(msg.sender);
        voters.push(v);
        return  address(v);
        
     }
     function  addElection() public returns (address){
        Election e= new Election();
        return address(e);

     }
     // 0x8016C461C198d4162F1115A8e3B949Bf53C79cCB
     // 0x0ce7FE7cf2ef266Eb8a53702dD97c1D60Bc36519


     function addCandidate(address election) public returns (address) {
        Candidate c= new Candidate(election);
        Election e = Election(election);
        e.addCandidate(c);
        return address(c);
     }

     function  vote(address election,address candidate, address voter ) public isValidUser  /*candidateExists(candidate,election) hasVoted(election)*/ returns (bool) {
       Voter v= Voter(voter);
       v.voteDone(election);
       v.setCandidateVote(candidate, election);
       Election e= Election(election);
       e.setVote(candidate);
      return true;

         // 0x528ea66286414F28E3154Ba5B9c7dE47a197c86F
         //  0xcf1c2d6b8282639C6A1f21754AB703Aa0931DD2B  0xc55fD61B2e05D675074Ac4d2B0F4184c2871BDED
     }
     function getResult(address election ) public view returns (address candidate , uint votes) {
         Election e= Election(election);
           (candidate,votes)=e.getMaxVote();

           return (candidate,votes);



     }

     modifier  isValidUser(){
      bool found= false;
      for(uint256 i=0 ;i< voters.length;i++){
        if (address(voters[i].getOwner())== msg.sender){
         found= true;
        }
      }
      if (!found){
         revert("voter has not been registered "); 
      }
      _;
     }


     modifier candidateExists(address election , address candidate ){
      Election e= Election(election);
      Candidate c= Candidate(candidate);
      bool found= false;
      for ( uint256 i=0 ;i< e.getLength();i++){
         if (e.getAddress(i)==candidate){
            found= true;
            break;

         }   // 0xb9c68FBA0FC33C7743B54EA72fE9eFdf3060B751   0xEF0A530DE77d7A0c9Ab69c9E7779deA0812eef64
      }
      if (!found){
            revert("your candidate has not registered for given election");
         }
   _;

      
     }
     modifier hasVoted(address election) {
      Voter v = Voter(msg.sender);
      require(!v.getVoteDetail(election),"voter has already voted in the given election");
      //m default value for bool would be false for all addresses 


      _;
     }
    


    




}
