// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import "./Election.sol";
import {GeneralBallot} from  "./GeneralBallot.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
contract ElectionFactory {

    
    address immutable owner; 
    mapping(uint256 election => address owner) electionToOwner;
    mapping(address owner => address[] election) ownerElections;
    uint256 public electionCount ;
    address electionGenerator;

    constructor(){
        owner = msg.sender;
        electionCount = 0;
        electionGenerator = address(new Election());
    }

    function createElection (
     
     Election.Candidate[] memory _candidates
    ) public returns (address) { 
        address electionAddress  = Clones.clone(electionGenerator);
        address ballot = address( new GeneralBallot(electionAddress));

    Election election = Election(electionAddress);
    election.initialize(_candidates,  msg.sender, ballot);
    electionCount++;
    return address(election);
    }



   



}