import React, { Component } from 'react'
import MerchantHub from '../build/contracts/MerchantHub.json'
import getWeb3 from './utils/getWeb3'

import './css/oswald.css'
import './css/open-sans.css'
import './css/pure-min.css'
import './App.css'

class App extends Component {
  constructor(props) {
    super(props)

    this.merchantHub = null;
    this.web3 = null;
    // this.state = {
    //   web3: null
    // }
  }

  _createMerchant(e){
    this.web3.eth.getAccounts((error, accounts) => {
      this.merchantHub.createMerchant({from: accounts[0]}).then((result) => {
        console.log(result);
      })
    })
  }

  componentWillMount() {
    // Get network provider and web3 instance.
    // See utils/getWeb3 for more info.

    getWeb3
    .then(results => {
      this.web3 = results.web3;


      // Instantiate contract once web3 provided.
      this.instantiateContract()
    })
    .catch(() => {
      console.log('Error finding web3.')
    })
  }

  instantiateContract() {
    const contract = require('truffle-contract')
    const merchantHub = contract(MerchantHub)
    merchantHub.setProvider(this.web3.currentProvider)

    // Get accounts.
    this.web3.eth.getAccounts((error, accounts) => {
      merchantHub.deployed().then((instance) => {
        this.merchantHub = instance;

        // Stores a given value, 5 by default.
        //return simpleStorageInstance.set(5, {from: accounts[0]})
      })
      // .then((result) => {
      //   // Get the value from the contract to prove it worked.
      //   return simpleStorageInstance.get.call(accounts[0])
      // }).then((result) => {
      //   // Update state with the result.
      //   return this.setState({ storageValue: result.c[0] })
      // })
    })
  }

  render() {
    return (
      <div className="App">
        <nav className="navbar pure-menu pure-menu-horizontal">
            <a href="#" className="pure-menu-heading pure-menu-link">Truffle Box</a>
        </nav>

        <main className="container">
          <div className="pure-g">
            <div className="pure-u-1-1">
              <h1>Create Merchant!</h1>
              <button onClick={() => this._createMerchant()}>Button</button>
            </div>
          </div>
        </main>
      </div>
    );
  }
}

export default App
