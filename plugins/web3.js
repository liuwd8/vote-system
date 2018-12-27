import Vue from 'vue'
import Web3 from 'web3'

export default () => {
  var web3 = window.web3
  if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider)
  } else {
    web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'))
  }
  Vue.prototype.$web3 = web3
  var abi = [{"constant":true,"inputs":[{"name":"ballotName","type":"bytes32"}],"name":"getProposals","outputs":[{"name":"","type":"bytes32[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"ballotName","type":"bytes32"},{"name":"proposalNames","type":"bytes32[]"}],"name":"InitiateVote","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"ballotName","type":"bytes32"}],"name":"winningProposal","outputs":[{"name":"winningProposal_","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getBallotTitiles","outputs":[{"name":"","type":"bytes32[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"ballotName","type":"bytes32"},{"name":"to","type":"address"}],"name":"delegate","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"ballotName","type":"bytes32"},{"name":"proposalNames","type":"bytes32"}],"name":"addProposal","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"ballotName","type":"bytes32"},{"name":"proposal","type":"uint256"}],"name":"vote","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"ballotName","type":"bytes32"}],"name":"winnerName","outputs":[{"name":"winnerName_","type":"bytes32"}],"payable":false,"stateMutability":"view","type":"function"}]
  var gethContractAddress = '0x88bc1b4b1b05f9d7b378673648fe73b1dbae4a98'
  web3.eth.getAccounts().then((data) => {
    web3.from = data[0]
    web3.ballotmanagerContract = new web3.eth.Contract(abi, '0x9342ba7ea1b1833e4070130252549a02021c1087')
  })
}