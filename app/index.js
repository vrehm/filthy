import React, { Component } from 'react';
import ReactDOM from 'react-dom';

import WashControl from './components/wash_control';
import PopUpForm from './components/find_collection_form';
import DirtyList from './components/dirty_list';

class App extends Component{

  constructor () {
    super ();

    this.state = { 
      popupOpen: false, 
      dirtyCollections: []
    };
    // bind this to class methods
    this._togglePopUpState = this._togglePopUpState.bind(this);
    this.addDirtyCollections = this.addDirtyCollections.bind(this);
  }

  addDirtyCollections (dirtyItem) {
    var dirtyArray = this.state.dirtyCollections;
    // check if id is allready in array.
    this.dirtyIsDuplicate(dirtyItem, dirtyArray) || dirtyArray.push(dirtyItem);
    // re-assign the value the state, as is tradition
    this.setState({dirtyCollections: dirtyArray});
  }

  // returns true or false
  dirtyIsDuplicate (dirty, array) {
    return array.map((data) => data.collection_data.id)
    .includes(dirty.collection_data.id);   
  }
  // toggle popup state
  _togglePopUpState () {
    this.setState({ 
      popupOpen: !this.state.popupOpen ? true : false  
    });
  }

  render () {
    return (
      <div>
        <aside>
          <WashControl handleClick={this._togglePopUpState} />
        </aside>
        <section>
          { this.state.popupOpen ? <PopUpForm addDirtyCollections={this.addDirtyCollections} /> : null }
          <DirtyList dirtyCollections={this.state.dirtyCollections} />
        </section>
      </div>
    );
  }
}

ReactDOM.render(<App />,  document.querySelector('.app'));