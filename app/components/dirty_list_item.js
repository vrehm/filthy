import React, { Component } from 'react';
import ColorList from './color_list';
import AddColorForm from './add_color_form';


class DirtyListItem extends Component {

  constructor(props) {
    super(props);

    this.state = {
      colors: props.dirtyItem.colors,
      sizes: props.dirtyItem.sizes
    } 

    this.addColor = this.addColor.bind(this);
    this.removeColor = this.removeColor.bind(this);
    this.addSize = this.addSize.bind(this);
  }

  addColor (color) {
    let colors = this.state.colors;
    colors.push(color);
    this.setState({colors: colors});
  }

  removeColor (i) {
    this.setState(state => {
      state.colors.splice(i, 1);
      return {colors: state.colors}
    });
  } 

  addSize (size) {
    let sizes = this.state.sizes;
    sizes.push(size);
    this.setState({sizes: sizes});
  }

  render() {
    return (
      <li className="list-group-item">
        <h2>{ this.props.dirtyItem.title }</h2>
        <AddColorForm addColor={ this.addColor }/>
        <ColorList removeColor={ this.removeColor } colors={ this.state.colors } />
        <button className="btn-success btn"> Clean </button>
      </li>
    )
  }
};

export default DirtyListItem;