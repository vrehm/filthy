import React, { Component } from 'react';

class AddColorForm extends Component {

  constructor (props) {
    super(props)

    this.state = {
      addColor: ''
    }

    this.addColorItem = this.addColorItem.bind(this);
  }

  addColorItem (e) {
    e.preventDefault();
    this.props.addColor(this.state.addColor);
  }

  render () {
    return(   
      <form onSubmit={this.addColorItem}>
        <input onChange={ (event) => this.setState({ addColor: event.target.value })  } type="text"/>
        <input type="submit"/>
      </form>
    )
  }
}

export default AddColorForm;