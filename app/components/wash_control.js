import React from 'react';

// import WashControl from './components/wash_control';


const WashControl = (props) => {
  return (
    <div> 
      <button onClick={props.handleClick}> Add Dirty Collection </button>
    </div>
  );
} 

export default WashControl;