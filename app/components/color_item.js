import React from 'react';

const ColorItem = (props) => {
  const color = props.color;
  return <li>{color}<button onClick={props.onClick}>remove</button> </li>
}

export default ColorItem;