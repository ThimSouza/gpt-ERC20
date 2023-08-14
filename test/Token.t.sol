// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
/*
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
    address public admin;
    string[] data;
    bytes32 public cHash;

    function setUp() public {
        mintValue = 10000000;
        burnValue = 5000000;
        data = [
            "idFazenda: 1",
            "fornecedor: Valtair",
            "documento: 927.909",
            "nome_fazenda: Estancia",
            "codigo_fazenda: 7602101060",
            "safra: 1",
            "ano: 2010",
            "quantidade: 2.429"
        ];
        name = "Greener Preservation Token";
        symbol = "GPT";
        initialSupply = 72000000000000;
        user = makeAddr("user");
        admin = makeAddr("admin");
        gptContract = new GPT(name, symbol, initialSupply, admin);
        GPT(gptContract).addOwnership(admin);
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
    }

    function test_compensate() public {
        gptContract.mint(user, mintValue);
        vm.prank(user);
        gptContract.approveBurner();
        vm.prank(admin);
        gptContract.compensate(user, burnValue, data);
        assertEq(GPT(gptContract).balanceOf(user), (mintValue - burnValue));
    }

    function test_retrieveData() public {
        gptContract.mint(user, mintValue);
        vm.prank(user);
        gptContract.approveBurner();
        vm.prank(admin);
        gptContract.compensate(user, burnValue, data);
        assertEq(GPT(gptContract).balanceOf(user), (mintValue - burnValue));
        /*assertEq(GPT(gptContract).compensatedData(cHash, 0), "idFazenda: 1");
        assertEq(
            GPT(gptContract).compensatedData(cHash, 1),
            "fornecedor: Valtair"
        );
        assertEq(
            GPT(gptContract).compensatedData(cHash, 2),
            "documento: 927.909"
        );
        assertEq(
            GPT(gptContract).compensatedData(cHash, 3),
            "nome_fazenda: Estancia"
        );
        assertEq(
            GPT(gptContract).compensatedData(cHash, 4),
            "codigo_fazenda: 7602101060"
        );
        assertEq(GPT(gptContract).compensatedData(cHash, 5), "safra: 1");
        assertEq(GPT(gptContract).compensatedData(cHash, 6), "ano: 2010");
        assertEq(
            GPT(gptContract).compensatedData(cHash, 7),
            "quantidade: 2.429"
        ); */
