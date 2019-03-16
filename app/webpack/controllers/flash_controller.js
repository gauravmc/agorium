import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "notification" ]

  remove(event) {
    this.notificationTarget.parentNode.removeChild(this.notificationTarget)
  }
}
