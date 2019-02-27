import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "section" ]

  remove(event) {
    this.removeNotification(event.target.parentNode)

    if (this.getFlashCount() === 0)
      this.removeFlashSection()
  }

  removeNotification(notification) {
    notification.parentNode.removeChild(notification)
    this.decrementFlashCount()
  }

  removeFlashSection() {
    this.sectionTarget.parentNode.removeChild(this.sectionTarget)
  }

  decrementFlashCount() {
    this.sectionTarget.dataset.flashCount = this.getFlashCount() - 1
  }

  getFlashCount() {
    return parseInt(this.data.get('count'))
  }
}
