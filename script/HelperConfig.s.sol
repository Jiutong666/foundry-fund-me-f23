// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script{

    NetworkConifg public activeNetworkConfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct  NetworkConifg {
        address priceFeed;
        
    }

    constructor(){
        if(block.chainid == 11155111){  //make sure u are on Sepolia chain
            activeNetworkConfig = getSepoliaEthConfig();
        }else if (block.chainid == 1){
            activeNetworkConfig = getMainnetEthConfig();
        }
        else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns(NetworkConifg memory){ 
        NetworkConifg memory sepoliaConfig = NetworkConifg({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaConfig;
    }

    
    function getMainnetEthConfig() public pure returns(NetworkConifg memory){ 
        NetworkConifg memory ethConfig = NetworkConifg({priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return ethConfig;
    }

    
    function getOrCreateAnvilEthConfig() public returns(NetworkConifg memory){

        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockPricedFeed = new MockV3Aggregator(DECIMALS,INITIAL_PRICE);
        NetworkConifg memory anvilConfig = NetworkConifg({
            priceFeed: address(mockPricedFeed)
            });
        return anvilConfig;
        vm.stopBroadcast();


    }

}