// Centralizaion vs Decentralization
// a single DB   vs Distributed Ledger
// s single BN   vs BN network

// governance --> voting
// A agenda --> by vote --> decision

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

// 실체가 없다
abstract contract ManagedAccess {
    address public owner;
    address public manager;

    constructor(address _owner, address _manager) {
        owner = _owner;
        manager = _manager;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not authorized");
        _;
    }

    modifier onlyManager() {
        require(
            msg.sender == manager,
            "You are not authorized to manage this contract"
        );
        _;
    }
}
