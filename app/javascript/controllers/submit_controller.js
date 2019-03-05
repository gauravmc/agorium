import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "button", "form" ]

  process(event) {
    if (this.formTarget.checkValidity())
      this.buttonTarget.classList.add('is-loading')
  }
}
