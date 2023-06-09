input = ["0x0843c2161ac252df1f7b10c8b3f56a42b5f6a253eb62cde7ced17a13abab4df9", "0x1443954d2de81ee7a508d8c5ed4378d036c49fa87dcc39aa2f5fbd7ade9772ac"],[["0x04eae46c3f20d15fc10444309ebdcb770deb031f4b93a3ec94520e69a861d6dd", "0x20e88c074bd6b32e4714e1b3ba51068af65a414c136a286d3bf37aa52a908648"],["0x305c48d0af507035842d92bee3e164730b867b4ba40dc781716f6e0cf7da33de", "0x14bfb25667fb5ebb827bf7fb3afa9318a05d7845ed4a9d7c4fc67a4f8bd01ed4"]],["0x2752c869670ac2b7c41ac337cee2842628e3b23a3c6807463775579dcdaa0b3e", "0x1683a230571dd85a4687c6c4bc21140913023d4e0dd2833d1aee3d104df95876"],["0x2ec2d13597576e6e9a28d337af768c614a0b892a38aece30dd4df4b1138edf35","0x11ef8fc9e658c40fa4a8ae1d40e81084befc8a507f560bb0f2c33bb14cca567d"]
const Web3 = require('web3')
const rpc = "http://localhost:8545"
const web3 = new Web3(rpc)
const addr = "0x7e71578abb86ae22a27905cb13589608e0c7b336"
const mimcAddr = "0xbFC64180eA9f459faac33f52c1F171688e0d54bb"
const passwd = ""
var fs = require('fs');  

var abi = JSON.parse(fs.readFileSync("./contracts/abi/mix_sol_mix.abi"));
// var bytecode = fs.readFileSync("./contracts/bin/mix_sol_mix.bin","utf-8");  
var mixAddr = "0x0f1caF2e32508035952fe8619c3819DA14C277bB"

web3.eth.personal.unlockAccount(addr, passwd, 6000)

var contract = new web3.eth.Contract(abi, mixAddr)
contract.methods.verifyProof(["0x0843c2161ac252df1f7b10c8b3f56a42b5f6a253eb62cde7ced17a13abab4df9", "0x1443954d2de81ee7a508d8c5ed4378d036c49fa87dcc39aa2f5fbd7ade9772ac"],[["0x04eae46c3f20d15fc10444309ebdcb770deb031f4b93a3ec94520e69a861d6dd", "0x20e88c074bd6b32e4714e1b3ba51068af65a414c136a286d3bf37aa52a908648"],["0x305c48d0af507035842d92bee3e164730b867b4ba40dc781716f6e0cf7da33de", "0x14bfb25667fb5ebb827bf7fb3afa9318a05d7845ed4a9d7c4fc67a4f8bd01ed4"]],["0x2752c869670ac2b7c41ac337cee2842628e3b23a3c6807463775579dcdaa0b3e", "0x1683a230571dd85a4687c6c4bc21140913023d4e0dd2833d1aee3d104df95876"],["0x2ec2d13597576e6e9a28d337af768c614a0b892a38aece30dd4df4b1138edf35","0x11ef8fc9e658c40fa4a8ae1d40e81084befc8a507f560bb0f2c33bb14cca567d"]).call()
.then(console.log);





