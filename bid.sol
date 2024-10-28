// SPDX-License-Identifier: MIT

pragma solidity > 0.8.20;

contract TestBid {
    //state variables:
    uint256 public initialValue;
    uint256 public startDate;
    uint256 public durationTime;
    uint256 private bestOfferValue;
    address private OfferWin;
    uint8 public light; // 0 = open, 1 = closed
    address public owner;
    mapping (address => uint256) public addValue;

    // Structure to store offers
    struct Offer {
        address bidder;
        uint256 value;
    }
    
    // Array to store all offers
    Offer[] public offers;

    constructor() {
        owner = msg.sender;
        initialValue = 1 gwei;
        startDate = block.timestamp;
        durationTime = startDate + 7 days;
    }

    // Show the offerer winner and value
    function getOfferWin() external view returns(address) {
        return OfferWin;
    }

    function getbestOfferValue() external view returns(uint256) {
        return bestOfferValue;
    }

    function setOffer() external payable {
        require(light==0,"The bid has finished");
        uint256 _offerValue = msg.value;
        require(_offerValue>initialValue,"Value less than initial");

        // Store the offer
        offers.push(Offer(msg.sender, _offerValue));

        if(_offerValue > bestOfferValue) {
            address _offererAddress = msg.sender;
            bestOfferValue = _offerValue;
            OfferWin = _offererAddress;
            addValue[_offererAddress] += _offerValue;
        } else {
            revert("You didn't beat the best offer");
        }
    }

    function endBid( ) external {
        require(owner==msg.sender,"You hasen't permission to close the bid");
        light = 1;
    }
        // Function to get the offers count
    function getOffersCount() external view returns (uint256) {
        return offers.length;
    }

    // Function to get offer details 
    function getOffer(uint256 index) external view returns (address, uint256) {
        require(index < offers.length, "Offer index out of bounds");
        Offer memory offer = offers[index];
        return (offer.bidder, offer.value);
    }

    //function to get all offers as an array of (address, value)
    function getAllOffers() external view returns (address[] memory, uint256[] memory) {
        uint256 count = offers.length;
        address[] memory bidders = new address[](count);
        uint256[] memory values = new uint256[](count);

        for (uint256 i = 0; i < count; i++) {
            bidders[i] = offers[i].bidder;
            values[i] = offers[i].value;
        }

        return (bidders, values);
    }

}
