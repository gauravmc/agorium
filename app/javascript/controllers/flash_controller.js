import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "section", "notification" ]

  remove() {
    this.removeNotification()

    if (this.getFlashCount() === 0)
      this.removeFlashSection()
  }

  removeNotification() {
    this.notificationTarget.parentNode.removeChild(this.notificationTarget)
    this.decrementFlashCount()
  }

  removeFlashSection() {
    this.sectionTarget.parentNode.removeChild(this.sectionTarget)
  }

  decrementFlashCount() {
    this.sectionTarget.dataset.flashCount = this.getFlashCount() - 1
  }

  getFlashCount() {
    return parseInt(this.sectionTarget.dataset.flashCount)
  }
}
