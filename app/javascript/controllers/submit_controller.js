import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "button" ]

  process(event) {
    this.buttonTarget.classList.add('is-loading')
  }
}
