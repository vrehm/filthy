import React, { Componenet } from 'react';



class DirtyListItem extends Component {

  constructor(props) {
    super(props);

    this.state = {
      colors: props.dirtyItem.colors,
      sizes: props.dirtyItem.sizes
    } 
    
    this.addColors = this.addColors.bind(this);
    this.addSizes = this.addSizes.bind(this);
  }

  addColors (color) {
    let colors = this.state.colors;
    colors.push(color);
    this.setState({colors: colors});
  } 

  addSizes (size) {
    let sizes = this.state.sizes;
    sizes.push(size);
    this.setState({sizes: sizes});
  }

  render() {
    return (
      <li>
      
      </li>
    )
  }
};

export default DirtyListItem;