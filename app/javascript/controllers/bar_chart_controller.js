import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["bar"]

  connect() {
    this.barTargets.forEach(bar => {
      requestAnimationFrame(() => {
        requestAnimationFrame(() => {
          bar.style.width = (bar.dataset.pct || 0) + "%"
        })
      })
    })
  }
}
