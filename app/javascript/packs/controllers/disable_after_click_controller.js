import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['item', 'spinner']
  static values = { enabled: Boolean }

  initialize() {
    this.enabledValue = true
    console.log(this.enabledValue)
  }

  disable(e) {
    if (this.enabledValue != false) {
      this.enabledValue = false
      this.itemTarget.classList.add('opacity-50')
      this.spinnerTarget.classList.remove('hidden')
    } else {
      e.preventDefault()
    }
  }
}
