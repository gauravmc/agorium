import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

console.log('App Pack')

const App = props => (
  <section className="section">
    <div className="container">
      <p className="subtitle">
        Welcome to Agorium, {props.name}! This message is coming from React.
      </p>
    </div>
  </section>
)

App.defaultProps = {
  name: 'David'
}

App.propTypes = {
  name: PropTypes.string
}

// Do not render anything from React for now

// document.addEventListener('DOMContentLoaded', () => {
//   ReactDOM.render(
//     <App name="<User Name>" />,
//     document.body.appendChild(document.createElement('div')),
//   )
// })

// TODO: Move this once React components are more properly set up
document.addEventListener('DOMContentLoaded', () => {
  const navbarBurger = document.querySelector('.navbar-burger')
  navbarBurger.addEventListener('click', () => {
    const target = document.getElementById(navbarBurger.dataset.target);
    navbarBurger.classList.toggle('is-active');
    target.classList.toggle('is-active');
  });
});
