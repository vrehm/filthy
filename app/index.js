import React, { Component } from 'react';
import ReactDOM from 'react-dom';

import WashControl from './components/wash_control';
import PopUpForm from './components/find_collection_form';

class App extends Component{

  constructor () {
    super ();

    this.state = { 
      popupOpen: false 
    };
    // bind on button click to this
    this._togglePopUpState = this._togglePopUpState.bind(this);
  }

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
          { this.state.popupOpen ?  <PopUpForm /> : null }
        </section>
      </div>
    );
  }
}

ReactDOM.render(<App />,  document.querySelector('.app'));