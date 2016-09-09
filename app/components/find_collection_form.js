import React, { Component } from 'react';

class PopUpForm extends Component {

  constructor (props) {
    super(props);

    this.state = {
      collectionName: 'Name Of Collection',
      collectionType: 'Custom Collection'
    };

    this._findCollection = this._findCollection.bind(this);
  }

  _findCollection (e) {
    e.preventDefault();
    // decide what url we're going to return from the input selection
    let url = this.state.collectionType == "Custom Collection" ? "/custom-collections/:" : "/smart-collections/:";
    // TODO create loading modal state
    console.log();
    // create promise of the dirty collection
    const diryCollection = fetch(url+this.state.collectionName.toLowerCase()); 
    // chain promise to return json and send data upstream
    diryCollection
      .then(data => data.json())
      // send dirty collection up stream to be washed
      .then(data => this.props.addDirtyCollections(data))
      // TODO Create Success message
      .catch((err) => {
        console.log(err);
        // TODO create error flash response message
      })
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