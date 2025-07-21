// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;



contract Crowdfunding {
    address public immutable owner;
    uint public campaignCount;


    struct Campaign {
        address payable creator;
        string title;
        string description;
        uint goalInETH;
        uint goalInUSD;
        uint deadline;
        uint raisedAmount;
        bool isFunded;
        bool isClosed;
    }

    mapping(uint => Campaign) public campaigns;
    mapping(uint => mapping(address => uint)) public contributions;

    bool private locked;

    event CampaignCreated(uint campaignId, address indexed creator, uint goalUSD, uint deadline);
    event Contributed(uint indexed campaignId, address indexed contributor, uint amount);
    event Refunded(uint indexed campaignId, address indexed contributor, uint amount);
    event FundsWithdrawn(uint indexed campaignId, address indexed creator, uint amount);

    modifier noReentrant() {
        require(!locked, "Reentrancy not allowed");
        locked = true;
        _;
        locked = false;
    }

    modifier validCampaign(uint _id) {
        require(_id > 0 && _id <= campaignCount, "Invalid campaign ID");
        _;
    }

    modifier onlyCreator(uint _id) {
        require(msg.sender == campaigns[_id].creator, "Not the campaign creator");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createCampaign(
        string calldata _title,
        string calldata _description,
        uint _goalUSD,
        uint _durationInSeconds
    ) external {
        require(_goalUSD > 0, "Goal must be greater than 0");
        require(_durationInSeconds >= 60, "Duration must be at least 1 minute");

        uint ethGoal = usdToEth(_goalUSD);
        uint deadline = block.timestamp + _durationInSeconds;
        campaignCount++;

        campaigns[campaignCount] = Campaign({
            creator: payable(msg.sender),
            title: _title,
            description: _description,
            goalInETH: ethGoal,
            goalInUSD: _goalUSD,
            deadline: deadline,
            raisedAmount: 0,
            isFunded: false,
            isClosed: false
        });

        emit CampaignCreated(campaignCount, msg.sender, _goalUSD, deadline);
    }

    function contribute(uint _campaignId) external payable validCampaign(_campaignId) {
        Campaign storage campaign = campaigns[_campaignId];

        require(block.timestamp < campaign.deadline, "Campaign expired");
        require(!campaign.isClosed, "Campaign is closed");
        require(msg.value > 0, "Must send some Ether");

        campaign.raisedAmount += msg.value;
        contributions[_campaignId][msg.sender] += msg.value;

        if (!campaign.isFunded && campaign.raisedAmount >= campaign.goalInETH) {
            campaign.isFunded = true;
        }

        emit Contributed(_campaignId, msg.sender, msg.value);
    }

    function withdrawFunds(uint _campaignId) external noReentrant validCampaign(_campaignId) onlyCreator(_campaignId) {
        Campaign storage campaign = campaigns[_campaignId];

        require(campaign.isFunded, "Goal not reached");
        require(!campaign.isClosed, "Already withdrawn");

        campaign.isClosed = true;

        uint amount = campaign.raisedAmount;
        campaign.raisedAmount = 0;

        (bool sent, ) = campaign.creator.call{value: amount}("");
        require(sent, "Transfer failed");

        emit FundsWithdrawn(_campaignId, msg.sender, amount);
    }

    function refund(uint _campaignId) external noReentrant validCampaign(_campaignId) {
        Campaign storage campaign = campaigns[_campaignId];

        require(block.timestamp >= campaign.deadline, "Campaign still active");
        require(!campaign.isFunded, "Campaign was successful");

        uint contributed = contributions[_campaignId][msg.sender];
        require(contributed > 0, "No funds to refund");

        contributions[_campaignId][msg.sender] = 0;
        campaign.raisedAmount -= contributed;

        (bool sent, ) = payable(msg.sender).call{value: contributed}("");
        require(sent, "Refund failed");

        emit Refunded(_campaignId, msg.sender, contributed);
    }

    function getContribution(uint _campaignId, address _user) external view validCampaign(_campaignId) returns (uint) {
        return contributions[_campaignId][_user];
    }

    function getCampaign(uint _campaignId) external view validCampaign(_campaignId) returns (Campaign memory) {
        return campaigns[_campaignId];
    }

    function usdToEth(uint _usdAmount) public pure returns (uint) {
        return _usdAmount * 5e14;
    }
}




//0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
//0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
//0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
