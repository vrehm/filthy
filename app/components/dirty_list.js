import React, { Component } from 'react';
import DirtyListItem from './dirty_list_item';


const DirtyList = (props) => {
  const dirtyItems = props.dirtyCollections.map((dirty)=>{
    return <DirtyListItem key={dirty.collection_data.id} dirtyItem={dirty.collection_data} />
  })

  return(
    <div className="dirty-list--wrapper">
      <ul className="list-group"> {dirtyItems} </ul>
    </div>
  )

}

export default DirtyList;