import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['item', 'spinner']

  initialize() {
  }

  // just make the button look disabled
  disable(e) {
    this.itemTarget.disabled = true
    this.itemTarget.classList.add('opacity-50')
    this.spinnerTarget.classList.remove('hidden')
  }
}
