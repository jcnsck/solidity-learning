// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./ManagedAccess.sol";

contract MyToken is ManagedAccess {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed spender, uint256 amount);

    string public name;
    string public symbol;
    uint8 public decimals;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimal,
        uint256 _amount
    ) ManagedAccess(msg.sender, msg.sender) {
        name = _name;
        symbol = _symbol;
        decimals = _decimal;
        // transaction
        // from, to, data, value, gas, ...
        _mint(_amount * 10 ** uint256(decimals), msg.sender); // 1 MT
    }

    function approve(address spender, uint256 amount) external {
        allowance[msg.sender][spender] = amount;
        emit Approval(spender, amount);
    }

    function transferFrom(address from, address to, uint256 amount) external {
        address spender = msg.sender;
        require(allowance[from][spender] >= amount, "insufficient allowance");
        allowance[from][spender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
    }

    function mint(uint256 amount, address to) external onlyManager {
        _mint(amount, to);
    }

    function setManager(address _manager) external onlyOwner {
        manager = _manager;
    }

    function _mint(uint256 amount, address to) internal {
        totalSupply += amount;
        balanceOf[to] += amount;

        // 무에서 화페를 발행시켜서 owner에게 줬다
        emit Transfer(address(0), to, amount);
    }

    function transfer(uint256 amount, address to) external {
        require(balanceOf[msg.sender] >= amount, "insufficient balance");

        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;

        emit Transfer(msg.sender, to, amount);
    }
}

/*
approve(다른 사람이 내 token을 보내게 한다 => 아주*n 신뢰할만한 곳에만 전달)
 - allow spender address to send my token
transferFrom(나의 token을 다른 주소로 보낸다)
 - spender: owner -> target address

* token owner --> bank contract
* token owner --> router contract --> bank contract
* token owner --> router contract --> bank contract(multi contract)

*/
