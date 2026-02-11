// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Governance is Ownable {
    enum ProposalState { Active, Defeated, Succeeded, Executed }

    struct Proposal {
        address target;
        uint256 value;
        bytes data;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 endBlock;
        bool executed;
    }

    IERC20 public govToken;
    uint256 public quorum;
    Proposal[] public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    constructor(address _govToken, uint256 _quorum) Ownable(msg.sender) {
        govToken = IERC20(_govToken);
        quorum = _quorum;
    }

    function createProposal(address _target, uint256 _value, bytes memory _data, uint256 _blocks) external {
        proposals.push(Proposal({
            target: _target,
            value: _value,
            data: _data,
            votesFor: 0,
            votesAgainst: 0,
            endBlock: block.number + _blocks,
            executed: false
        }));
    }

    function vote(uint256 _propId, bool _support) external {
        Proposal storage p = proposals[_propId];
        require(block.number < p.endBlock, "Voting ended");
        require(!hasVoted[_propId][msg.sender], "Already voted");

        uint256 weight = govToken.balanceOf(msg.sender);
        require(weight > 0, "No voting power");

        if (_support) p.votesFor += weight;
        else p.votesAgainst += weight;

        hasVoted[_propId][msg.sender] = true;
    }

    function execute(uint256 _propId) external payable {
        Proposal storage p = proposals[_propId];
        require(block.number >= p.endBlock, "Voting active");
        require(!p.executed, "Already executed");
        require(p.votesFor > p.votesAgainst, "Proposal failed");
        require(p.votesFor + p.votesAgainst >= quorum, "Quorum not met");

        p.executed = true;
        (bool success, ) = p.target.call{value: p.value}(p.data);
        require(success, "Execution failed");
    }
}
