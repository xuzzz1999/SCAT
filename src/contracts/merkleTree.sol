pragma solidity ^0.5.0;

import { MiMCpe7_generated } from "./mimc.sol";

contract IMimc { 
  function MiMCpe7(uint256 in_x,uint256 in_k) public returns(uint256 out_x) {
    return MiMCpe7_generated.MiMCpe7(in_x, in_k);
  }
}

contract MerkelTree {
    mapping (uint256 => bool) public roots; // 记录Merkle tree上的root
    uint public tree_depth = 8; 
    uint public no_leaves = 256; 
    struct Mtree {
        uint256 cur;
        uint256[256][9] leaves2; 
    }

    Mtree public MT;

    IMimc mimc;

    event LeafAdded(uint256 index);
    
    event TestMimc(uint256);
    
    event MerkleProof(uint256[8] , uint256[8] );

    constructor(address _mimc) public{
        mimc = IMimc(_mimc);
    }

    //Merkletree.append(com)
    // 插入 commitment叶子节点
    function insert(uint256 com) public returns (uint256 ) {
        require (MT.cur != no_leaves );
        MT.leaves2[0][MT.cur] = com;
        updateTree();
        emit LeafAdded(MT.cur);
        MT.cur++;
   
        return MT.cur-1;
    }


    // 返回path，index
    function getMerkelProof(uint256 index) public returns (uint256[8] memory, uint256[8] memory) {

        uint256[8] memory address_bits;
        uint256[8] memory merkelProof;

        for (uint256 i=0 ; i < tree_depth; i++) {
            // address_bits[i] = index%2;
            if (index%2 == 0) {
                address_bits[i]=1;
                merkelProof[i] = getUniqueLeaf(MT.leaves2[i][index + 1],i);
            }
            else {
                address_bits[i]=0;
                merkelProof[i] = getUniqueLeaf(MT.leaves2[i][index - 1],i);
            }
            index = uint256(index/2);
        }
        emit MerkleProof(merkelProof, address_bits);
        return(merkelProof, address_bits);   
    }
    
    function getMimc(uint256 input, uint256 sk) public returns ( uint256) { 
        emit TestMimc(mimc.MiMCpe7(input , sk));
        return mimc.MiMCpe7(input , sk); 
    }

    function getUniqueLeaf(uint256 leaf, uint256 depth) public returns (uint256) {
        if (leaf == 0) {
            for (uint256 i=0;i<depth;i++) {
                leaf = mimc.MiMCpe7(leaf, leaf);
            }
        }
        return (leaf);
    }
    
    // 更新Merkle  tree
    function updateTree() public returns(uint256 root) {
        uint256 CurrentIndex = MT.cur;
        uint256 leaf1;
        uint256 leaf2;
        for (uint256 i=0 ; i < tree_depth; i++) {
            uint256 NextIndex = CurrentIndex/2;
            if (CurrentIndex%2 == 0) {
                leaf1 =  MT.leaves2[i][CurrentIndex];
                leaf2 = getUniqueLeaf(MT.leaves2[i][CurrentIndex + 1], i);
            } else {
                leaf1 = getUniqueLeaf(MT.leaves2[i][CurrentIndex - 1], i);
                leaf2 =  MT.leaves2[i][CurrentIndex];
            }
            MT.leaves2[i+1][NextIndex] = mimc.MiMCpe7( leaf1, leaf2);
            CurrentIndex = NextIndex;
        }
        return MT.leaves2[tree_depth][0];
    }
    
   
    function getLeaf(uint256 j,uint256 k) public view returns (uint256 root) {
        root = MT.leaves2[j][k];
    }

    // 返回Merkle tree root
    function getRoot() public view returns(uint256 root) {
        root = MT.leaves2[tree_depth][0];
    }

}