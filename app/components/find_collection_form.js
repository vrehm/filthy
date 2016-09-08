import React from 'react';

const PopUpForm = () => {
  return (
    <div className="popUpForm">
      <form>
        <p> What Is The Name Of The Collection You Want To Clean? </p>
        Name: <input type="text"  />
        <p> Select type </p>
        Type: <input type="radio" id="r1" /><label for="r1"> Smart Collection </label>
              <input type="radio" id="r2" /><label for="r2"> Custom Collection </label>
        <input type="submit" value="Submit" />
      </form>
    </div>
  );
}

export default PopUpForm;