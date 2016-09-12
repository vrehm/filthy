import React, { Component } from 'react';
import ReactDOM from 'react-dom';
import WashControl from './components/wash_control';
import DirtyList from './components/dirty_list';
import AddDirty from './components/add_dirty';

class App extends Component{

  constructor () {
    super ();

    this.state = { 
      dirtyOpen: false,
      dirtyCollections: []
    };
    // bind this to class methods
    this._toggleDirty = this._toggleDirty.bind(this);
    this.addDirtyCollections = this.addDirtyCollections.bind(this);
  }

  addDirtyCollections (dirtyItem) {
    var dirtyArray = this.state.dirtyCollections;
    // check if id is allready in array.
    this.dirtyIsADuplicate(dirtyItem, dirtyArray) || dirtyArray.push(dirtyItem);
    // re-assign the value the state, as is tradition
    this.setState({dirtyCollections: dirtyArray});
  }

  // returns true or false
  dirtyIsADuplicate (dirty, array) {
    // map an array of collection id's and check if dirty is a duplicate
    return array.map((data) => data.collection_data.id)
    .includes(dirty.collection_data.id);   
  }
  // toggle popup state from wash_control.js
  _toggleDirty () {
    this.setState({ 
      dirtyOpen: !this.state.dirtyOpen ? true : false
    });
  }

  render () {
    return (

      <div className="container-fluid">
        <div className="row">
          <aside className="col-sm-2 left-aside">
            <WashControl handleClick={this._toggleDirty} />
          </aside>
          <section className='col-sm-5 dirty-section'>
            <div className="dirty-section--header">
              <h2> Dirty List </h2>
            </div>
            <DirtyList dirtyCollections={this.state.dirtyCollections} />
          </section>
        </div>
        <AddDirty show={this.state.dirtyOpen} 
                  onHide={this._toggleDirty} 
                  addDirtyCollections={this.addDirtyCollections} />
      </div>


    );
  }
}

ReactDOM.render(<App />,  document.querySelector('.app'));