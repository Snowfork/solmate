// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {DSTestPlus} from "./utils/DSTestPlus.sol";

import {MerkleProofLib} from "../utils/MerkleProofLib.sol";

contract MerkleProofLibTest is DSTestPlus {
    function testVerifyEmptyMerkleProofSuppliedLeafAndRootSame() public {
        bytes32[] memory proof;
        assertBoolEq(this.verify(proof, 0x00, 0x00), true);
    }

    function testVerifyEmptyMerkleProofSuppliedLeafAndRootDifferent() public {
        bytes32[] memory proof;
        bytes32 leaf = "a";
        assertBoolEq(this.verify(proof, 0x00, leaf), false);
    }

    function testVerifyValidProofSupplied() public {
        // Merkle tree created from leaves ['a', 'b', 'c'].
        // Leaf is 'a'.
        bytes32[] memory proof = new bytes32[](2);
        proof[0] = 0xb5553de315e0edf504d9150af82dafa5c4667fa618ed0a6f19c69b41166c5510;
        proof[1] = 0x0b42b6393c1f53060fe3ddbfcd7aadcca894465a5a438f69c87d790b2299b9b2;
        bytes32 root = 0x5842148bc6ebeb52af882a317c765fccd3ae80589b21a9b8cbf21abb630e46a7;
        bytes32 leaf = 0x3ac225168df54212a25c1c01fd35bebfea408fdac2e31ddd6f80a4bbf9a5f1cb;
        assertBoolEq(this.verify(proof, root, leaf), true);
    }

    function testVerifyShortProofSupplied() public {
        // Merkle tree created from leaves ['a', 'b', 'c'].
        // Leaf is 'c'.
        bytes32[] memory proof = new bytes32[](1);
        proof[0] = 0x805b21d846b189efaeb0377d6bb0d201b3872a363e607c25088f025b0c6ae1f8;
        bytes32 root = 0x5842148bc6ebeb52af882a317c765fccd3ae80589b21a9b8cbf21abb630e46a7;
        bytes32 leaf = 0x0b42b6393c1f53060fe3ddbfcd7aadcca894465a5a438f69c87d790b2299b9b2;

        assertBoolEq(this.verify(proof, root, leaf), true);
    }

    function testVerifyLargeProofSupplied() public {
        // Merkle tree created from leaves ['1', '2', '3', ..., '1000'].
        // Leaf is '42'.
        bytes32[] memory proof = new bytes32[](10);
        proof[0] = 0xcb7c14ce178f56e2e8d86ab33ebc0ae081ba8556a00cd122038841867181caac;
        proof[1] = 0x081c6649d757735e00e82890581518fc42224f0942420fe385ccb1ee67fb5c34;
        proof[2] = 0x6e077cb1dd754700e9f78cb6107b091478fbc6d9039792a4dcdecdee8c316f28;
        proof[3] = 0x06bb7e8a1517e2c41f6583fb693aa50f81e2db3e8aee43b105732f425f26b832;
        proof[4] = 0x4ecb91ca93d01dbee0cd88bec35d95e275de0f3c76a651c57b626bbee417e14e;
        proof[5] = 0xf78b5b2a0d2098d5690099983e7875e3a2274b985023d3cf48088b168f543b74;
        proof[6] = 0x2084f0e5584a39ae0c863c1f95799baa90aafe318185f6a9f67ae11098efbf99;
        proof[7] = 0x355564742ce4c22df4630c1a84466e23dd8339343fe3e2a67bfb0adce6a4d626;
        proof[8] = 0xc751a2cbefe4b10e2108a92131dfda6788a4059aa5a9b87aa001935a189de909;
        proof[9] = 0x698159e44c47a9a66f4efa7fdf710e7b00ae3c3d95522376cacc3580ad5600d3;
        bytes32 root = 0x147c1ac0abf462d97b0f59c5d3616f81c96566d1e2ddab5359f16c3bf0b48cc9;
        bytes32 leaf = 0xbeced09521047d05b8960b7e7bcc1d1292cf3e4b2a6b63f48335cbde5f7545d2;

        assertBoolEq(this.verify(proof, root, leaf), true);
    }

    function testVerifyInvalidProofSupplied() public {
        // Merkle tree created from leaves ['a', 'b', 'c'].
        // Leaf is 'a'.
        // Proof is same as testValidProofSupplied but last byte of first element is modified.
        bytes32[] memory proof = new bytes32[](2);
        proof[0] = 0xb5553de315e0edf504d9150af82dafa5c4667fa618ed0a6f19c69b41166c5511;
        proof[1] = 0x0b42b6393c1f53060fe3ddbfcd7aadcca894465a5a438f69c87d790b2299b9b2;
        bytes32 root = 0x5842148bc6ebeb52af882a317c765fccd3ae80589b21a9b8cbf21abb630e46a7;
        bytes32 leaf = 0x3ac225168df54212a25c1c01fd35bebfea408fdac2e31ddd6f80a4bbf9a5f1cb;
        assertBoolEq(this.verify(proof, root, leaf), false);
    }

    function verify(
        bytes32[] calldata proof,
        bytes32 root,
        bytes32 leaf
    ) external pure returns (bool) {
        return MerkleProofLib.verify(proof, root, leaf);
    }
}
