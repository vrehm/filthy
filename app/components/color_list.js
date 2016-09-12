import React, { Component } from 'react';
import ColorItem from './color_item';


class ColorList extends Component {

  constructor(props){
    super(props);
  }

  removeItem (i) {
    this.props.removeColor(i);
  }

  render () {
    const colors = this.props.colors.map((color, i) => {
      return <ColorItem onClick={this.removeItem.bind(this, i)} key={color} color={color} />
    });
    
    return(
      <div className="color-list">
        <ul className="list-group">{ colors }</ul>
      </div>
    );
  }
} 

export default ColorList;