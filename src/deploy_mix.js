const Web3 = require('web3')
const rpc = "http://localhost:8545"
const web3 = new Web3(rpc)
const addr = "0x7e71578abb86ae22a27905cb13589608e0c7b336"
const mimcAddr = "0xbFC64180eA9f459faac33f52c1F171688e0d54bb"
const passwd = ""

var fs = require('fs');  

var abi = JSON.parse(fs.readFileSync("./contracts/abi/mix_sol_mix.abi"));
var bytecode = fs.readFileSync("./contracts/bin/mix_sol_mix.bin","utf-8");  

var contract = new web3.eth.Contract(abi); 
web3.eth.personal.unlockAccount(addr, passwd, 6000)

contract.deploy({
    data: bytecode,
    arguments: [mimcAddr]
})
.send({
    from: addr,
    gas: 3000000,
    gasPrice: '3000000000'
}, function(error, transactionHash){ console.log("transactionHash:"+transactionHash) })
.on('receipt', function(receipt){
   console.log("contractAddress:"+receipt.contractAddress)
})







