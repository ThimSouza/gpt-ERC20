// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "ds-test/test.sol";
import "forge-std/Test.sol";
import "../src/Token.sol";

contract TokenTest is DSTest, Test {
    GPT public gptContract;
    uint256 public mintValue;
    uint256 public burnValue;
    string public name;
    string public symbol;
    uint256 public initialSupply;
    address public user;
    address public burner;
    string[] _dataDeploy;
    string[] _dataCompensate;

    function setUp() public {
        mintValue = 10000000;
        burnValue = 5000000;
        _dataDeploy = [
            "linkCPRVerde1.com.br/cprverde",
            "cprverde/linkCPRVerde2.com.br/cprverde",
            "cprvPRVerde3.com.br/cprverde",
            "cinkCPRVerde4.com.br/cprverde"
        ];
        _dataCompensate = [
            "linkCPRVerde1.com.br/cprverde",
            "Toneladas de carbono: 1",
            "cprverde/linkCPRVerde2.com.br/cprverde",
            "Toneladas de carbono: 8"
        ];
        name = "Greener Preservation Token";
        symbol = "GPT";
        initialSupply = 72000000000000;
        user = makeAddr("user");
        burner = makeAddr("burner");
        gptContract = new GPT(name, symbol, initialSupply, _dataDeploy);
    }

    function test_createToken() public {
        assertEq(GPT(gptContract).name(), name);
        assertEq(GPT(gptContract).symbol(), symbol);
        assertEq(GPT(gptContract).totalSupply(), initialSupply);
        assertEq(GPT(gptContract).decimals(), 6);
    }

    function test_mint() public {
        gptContract.mint(user, mintValue);

        assertEq(GPT(gptContract).balanceOf(user), mintValue);
        assertEq(GPT(gptContract).totalSupply(), (initialSupply + mintValue));
    }

    function test_compensate() public {
        gptContract.mint(user, mintValue);
        vm.prank(user);
        vm.expectRevert();
        gptContract.compensate(user, burnValue, _dataCompensate);
        gptContract.compensate(user, burnValue, _dataCompensate);
        assertEq(GPT(gptContract).balanceOf(user), (mintValue - burnValue));
    }

    function test_retrieveData() public {
        assertEq(
            GPT(gptContract).cprLinks(0),
            ("linkCPRVerde1.com.br/cprverde")
        );
        assertEq(
            GPT(gptContract).cprLinks(1),
            ("cprverde/linkCPRVerde2.com.br/cprverde")
        );
        assertEq(
            GPT(gptContract).cprLinks(2),
            ("cprvPRVerde3.com.br/cprverde")
        );
        assertEq(
            GPT(gptContract).cprLinks(3),
            ("cinkCPRVerde4.com.br/cprverde")
        );
    }

    function test_3rdPartyMint() public {
        vm.prank(burner);
        vm.expectRevert();
        gptContract.mint(user, mintValue);
        gptContract.giveMintBurnRole(burner);
        vm.prank(burner);
        gptContract.mint(user, mintValue);
        assertEq(GPT(gptContract).balanceOf(user), mintValue);
        assertEq(GPT(gptContract).totalSupply(), (initialSupply + mintValue));
    }

    function test_3rdPartyBurn() public {
        gptContract.mint(user, mintValue);
        vm.prank(burner);
        vm.expectRevert();
        gptContract.burn(user, mintValue);
        assertEq(GPT(gptContract).balanceOf(user), mintValue);
        assertEq(GPT(gptContract).totalSupply(), (initialSupply + mintValue));
        gptContract.giveMintBurnRole(burner);
        vm.prank(burner);
        gptContract.burn(user, mintValue);
        assertEq(GPT(gptContract).totalSupply(), initialSupply);
        assertEq(GPT(gptContract).balanceOf(user), 0);
    }

    function test_revertCompensate() public {
        gptContract.mint(user, mintValue);
        vm.prank(user);
        vm.expectRevert();
        gptContract.compensate(user, burnValue, _dataCompensate);
        gptContract.giveMintBurnRole(burner);
        vm.prank(burner);
        vm.expectRevert();
        gptContract.compensate(user, burnValue, _dataCompensate);
        vm.prank(burner);
        gptContract.mint(user, mintValue);
        assertEq(GPT(gptContract).balanceOf(user), (mintValue + mintValue));
    }
}
