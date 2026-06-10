import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]
  static values = { active: { type: String, default: "all" } }

  switch(event) {
    event.preventDefault()
    this.activeValue = event.currentTarget.dataset.tab
  }

  activeValueChanged(value) {
    this.tabTargets.forEach(tab => {
      tab.classList.toggle("active", tab.dataset.tab === value)
    })

    this.panelTargets.forEach(panel => {
      panel.hidden = panel.dataset.panel !== value
    })
  }
}
