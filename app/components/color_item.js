import React from 'react';

const ColorItem = (props) => {
  const color = props.color;
  return <li className="list-group-item">{color}<button className="pull-right btn btn-danger" onClick={props.onClick}>remove</button> </li>
}

export default ColorItem;