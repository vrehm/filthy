import React, { Component } from 'react';
import { Modal } from 'react-bootstrap';
import { Button } from 'react-bootstrap';

class AddDirty extends Component {

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
    const toggleLoading = () => document.querySelector('body').classList.toggle('loading');
    // TODO create loading modal state
    // toggle the body class olf loading and the modal overlay popsup
    toggleLoading();
    // close the modal
    this.props.onHide();
    // create promise of the dirty collection
    const diryCollection = fetch(url+this.state.collectionName.toLowerCase()); 
    // chain promise to return json and send data upstream
    diryCollection
      .then(data => {
        // close the loading modal
        toggleLoading();
        // transform the data to json
        return data.json();
      })
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
      <Modal show={this.props.show} onHide={this.props.onHide} bsSize="small" >

        <Modal.Header closeButton>
          <Modal.Title>Modal heading</Modal.Title>
        </Modal.Header>

        <Modal.Body>
          <form onSubmit={ this._findCollection }>
            <input
              onChange={ (event) => this.setState({ collectionName: event.target.value }) } 
              type="text" 
              value={ this.state.collectionName } />

            <select onChange={ (event) => this.setState({ collectionType: event.target.value }) }>
              <option value="Custom Collection">Custom Collection</option>
              <option value="Smart Collection">Smart Collection</option>
            </select>

            <Modal.Footer>
              <Button type="submit">Find</Button>
              <Button onClick={this.props.onHide}>Close</Button>
            </Modal.Footer>
          </form>
        </Modal.Body>
      </Modal>
    );
  }
}

export default AddDirty;