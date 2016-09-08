import React, { Component } from 'react';

class PopUpForm extends Component {

  constructor () {
    super();

    this.state = {
      collectionName: 'name of collection',
      collectionType: ''
    };

    this._findCollection = this._findCollection.bind(this);
  }

  _findCollection (e) {
    e.preventDefault();
    const diryCollection = fetch(`http://`) 
  }

  render () {
    return (
      <div className="popUpForm">
        <form onSubmit={ this._findCollection }>
          <p> What Is The Name Of The Collection You Want To Clean? </p>

          <input 
            onChange={ (event) => this.setState({ collectionName: event.target.value }) } 
            type="text" 
            value={ this.state.collectionName } />
          <p> What is The Type Of That Collection ?</p>

          <select onChange={ (event) => this.setState({ collectionType: event.target.value }) }>
            <option value="Custom Collection">Custom Collection</option>
            <option value="Smart Collection">Smart Collection</option>
          </select>
          <button > Find Dirty Collection </button>
        </form>
        
      </div>
    );
  }
}

export default PopUpForm;