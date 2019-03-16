import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "filenames" ]

  updateFilenames(event) {
    const input = event.target

    if (input.files.length > 0) {
      this.filenamesTarget.innerHTML = ''
      Array.from(input.files).forEach(file => {
        this.appendFilename(file.name)
      })
    }
  }

  appendFilename(filename) {
    const el = document.createElement('span')
    el.classList.add('file-name')
    el.innerHTML = filename
    this.filenamesTarget.appendChild(el)
  }
}
