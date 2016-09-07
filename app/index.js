import React from 'react';
import ReactDOM from 'react-dom';

import WashControl from './components/wash_control';

const App = () => {
  return (
    <aside>
      <WashControl />
    </aside>
  );
}

ReactDOM.render(<App />,  document.querySelector('.app'));