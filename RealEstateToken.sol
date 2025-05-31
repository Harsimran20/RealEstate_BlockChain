// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RealEstateMarket {
    struct Property {
        uint256 id;
        address payable owner;
        string location;
        uint256 price;
        bool isSold;
    }

    uint256 public nextPropertyId;
    mapping(uint256 => Property) public properties;

    event PropertyListed(uint256 id, address indexed owner, uint256 price);
    event PropertyPurchased(uint256 id, address indexed newOwner, uint256 price);

    function listProperty(string calldata location, uint256 price) external {
        properties[nextPropertyId] = Property({
            id: nextPropertyId,
            owner: payable(msg.sender),
            location: location,
            price: price,
            isSold: false
        });
        emit PropertyListed(nextPropertyId, msg.sender, price);
        nextPropertyId++;
    }

    function buyProperty(uint256 propertyId) external payable {
        Property storage prop = properties[propertyId];
        require(!prop.isSold, "Already sold");
        require(msg.value == prop.price, "Incorrect value");

        prop.owner.transfer(msg.value);
        prop.owner = payable(msg.sender);
        prop.isSold = true;

        emit PropertyPurchased(propertyId, msg.sender, msg.value);
    }

    function getProperty(uint256 propertyId) external view returns (Property memory) {
        return properties[propertyId];
    }
}





