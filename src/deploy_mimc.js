const Web3 = require('web3')
const rpc = "http://localhost:8545"
const web3 = new Web3(rpc)
const addr = "0x7e71578abb86ae22a27905cb13589608e0c7b336"
const passwd = ""

var fs = require('fs'); 

var abi = JSON.parse(fs.readFileSync("./contracts/abi/merkleTree_sol_IMimc.abi"));
var bytecode = fs.readFileSync("./contracts/bin/merkleTree_sol_IMimc.bin","utf-8");  

var contract = new web3.eth.Contract(abi); 
web3.eth.personal.unlockAccount(addr, passwd, 6000)

contract.deploy({
    data: bytecode,
})
.send({
    from: addr,
    gas: 3000000,
    gasPrice: '3000000000'
}, function(error, transactionHash){ console.log("transactionHash:"+transactionHash) })
.on('receipt', function(receipt){
   console.log("contractAddress:"+receipt.contractAddress)
})







