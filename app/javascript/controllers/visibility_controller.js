import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "section" ]

  toggle() {
    this.sectionTargets.forEach(function(section) {
      section.classList.toggle('is-active')
    });
  }
}
