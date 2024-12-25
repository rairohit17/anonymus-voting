 // SPDX-License-Identifier: MIT
pragma solidity 0.8.26;


contract Candidate{
    address  public candidate;
    address  public  electionToContest;
    constructor( address election){
        electionToContest= election;
        candidate=msg.sender;
    }

    
}