pragma solidity ^0.5.0;

import "./merkleTree.sol";
import "./verifier.sol";

contract mix is MerkelTree ,Verifier {
    mapping(uint256 => bool) public roots; // 记录所有合法的Merkle tree root
    mapping(uint256 => bool) public nullifierHashes; // 防止双花
    mapping(uint256 => bool) public commitments; // 防止相同存款
    

    uint256 constant public AMOUNT = 0.01 ether;

    event Deposit(uint256 indexed commitment, uint256 leafIndex, uint256 timestamp);
    event Withdraw(address to, uint256 nullifierHash);
    event Forward(uint256 indexed commitment, uint256 leafIndex, uint256 timestamp);

    // Constructor
    constructor  (address _mimc) MerkelTree(_mimc) public {
        
    }
    

    function deposit (uint256 _commitment) payable public{
        require(!commitments[_commitment], "same commitment");
    
        require(msg.value == AMOUNT);
        uint256 insertedIndex = insert(_commitment);
        commitments[_commitment] = true;
        roots[getRoot()] = true;
        emit Deposit(_commitment,insertedIndex,block.timestamp);
    }

    function withdraw(uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[2] memory input) public payable {
                
        uint256 _nullifierHash = uint256(input[1]);
        uint256 _root = uint256(input[0]);

        require(!nullifierHashes[_nullifierHash], "The coin has been already spent");
        require(isKnownRoot(_root), "fake root"); 
        require(verifyProof(a,b,c,input), "Invalid proof");

        nullifierHashes[_nullifierHash] = true;
        msg.sender.transfer(AMOUNT); // 打钱
        emit Withdraw(msg.sender, _nullifierHash);
    }

    function forward (
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[2] memory input,
            uint256 _commitment
) public returns (address) {

        uint256 _nullifierHash = uint256(input[1]);
        uint256 _root = uint256(input[0]);
        
        require(!commitments[_commitment], "same commitment");
        require(!nullifierHashes[_nullifierHash], "The coin has been already spent");
        require(isKnownRoot(_root), "fake root"); 
        require(verifyProof(a,b,c,input), "Invalid proof");

      
        uint insertedIndex = insert(_commitment);
        roots[getRoot()] = true;
       
        nullifierHashes[_nullifierHash] = true;
        emit Forward(_commitment,insertedIndex,block.timestamp);
    }

    function isKnownRoot(uint256 _root) public returns(bool){
        return roots[_root];
    }

}