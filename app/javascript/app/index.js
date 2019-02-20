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

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <App name="<User Name>" />,
    document.body.appendChild(document.createElement('div')),
  )
})
