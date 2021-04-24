import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['dayInfo', 'currentDay', 'upArrowTr', 'downArrowTr']

  initialize() {
    this.thresh = 7
    this.days = this.dayInfoTargets.length
    // short circuit return if there are less than 7 days
    if (this.days <= this.thresh) {
      this.hideDownArrow()
      this.hideUpArrow()
      return
    }

    if (this.hasCurrentDayTarget) {
      this.current_day = parseInt(this.currentDayTarget.id.split('day_row')[1])
    } else {
      // if there is no current_day then reading plan is done so show all days
      this.hideDownArrow()
      this.hideUpArrow()
      return
    }

    this.close_to_start = (this.current_day + 1) <= (parseInt(this.thresh / 2) + 1)
    this.close_to_end = (this.days - this.current_day) <= (parseInt(this.thresh / 2) + 1)

    this.topIndex = null
    this.bottomIndex = null

    //console.log(this.current_day)
    if (this.close_to_start) {
      // hide only the bottom plan days
      this.bottomIndex = this.thresh - 1
      //console.log('close to start')
    } else if (this.close_to_end) {
      //console.log('close to end')
      // hide only the top plan days
      this.topIndex = this.days - this.thresh
    } else {
      //console.log('NOT close to start or end')
      // hide both top and bottom plan days
      this.topIndex = this.current_day - parseInt(this.thresh / 2)
      this.bottomIndex = this.current_day + parseInt(this.thresh / 2)
    }

    if (this.topIndex == null) {
      this.hideDownArrow()
    } else {
      // hide top items
      this.dayInfoTargets.forEach((element, index) => {
        if (index < this.topIndex ) {
          element.classList.add('hidden')
          // also hide associated spacer row
          let spacer_row = document.getElementById('day_row' + index + 'b')
          spacer_row.classList.add('hidden')
        }
      })
    }

    if (this.bottomIndex == null) {
      this.hideUpArrow()
    } else {
      // hide bottom items
      this.dayInfoTargets.forEach((element, index) => {
        if (index > this.bottomIndex ) {
          element.classList.add('hidden')
          // also hide associated spacer row
          let spacer_row = document.getElementById('day_row' + index + 'b')
          spacer_row.classList.add('hidden')
        }
      })
    }
  }

  showTop(e) {
    this.hideDownArrow()

    this.dayInfoTargets.forEach((element, index) => {
      if (index < this.topIndex ) {
        element.classList.remove('hidden')
        // also hide associated spacer row
        let spacer_row = document.getElementById('day_row' + index + 'b')
        spacer_row.classList.remove('hidden')
      }
    })
  }

  showBottom(e) {
    this.hideUpArrow()

    this.dayInfoTargets.forEach((element, index) => {
      if (index > this.topIndex ) {
        element.classList.remove('hidden')
        // also hide associated spacer row
        let spacer_row = document.getElementById('day_row' + index + 'b')
        spacer_row.classList.remove('hidden')
      }
    })
  }

  hideDownArrow() {
    this.downArrowTrTarget.classList.add('hidden')
  }

  hideUpArrow() {
    this.upArrowTrTarget.classList.add('hidden')
  }
}
