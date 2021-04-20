import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['dayInfo', 'currentDay']

  connect() {
    // work on this later
    return

    const days = this.dayInfoTargets.length
    let current_day = null
    // if there is no current_day it means the reading plan is done so
    // shortcircuit exit
    if (this.hasCurrentDayTarget) {
      current_day = this.currentDayTarget.id.split('day_row')[1]
    } else {
      return;
    }

    this.dayInfoTargets.forEach((element, index) => {
      if (element.id !== ('day_row' + current_day) ) {
        element.classList.add('hidden')
        // also hide associated spacer row
        let spacer_row = document.getElementById('day_row' + index + 'b')
        spacer_row.classList.add('hidden')
      }
    })
  }
}
