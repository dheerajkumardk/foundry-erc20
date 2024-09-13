// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {ApnaToken} from "../src/ApnaToken.sol";

contract DeployApnaToken is Script {
    uint256 public constant INITIAL_SUPPLY = 1000 ether;
    
    function run() external returns (ApnaToken) {
        vm.startBroadcast();
        ApnaToken token = new ApnaToken(INITIAL_SUPPLY);
        vm.stopBroadcast();

        return token;
    }
}
