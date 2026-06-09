import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]
  static values = { active: { type: String, default: "all" } }

  switch(event) {
    this.activeValue = event.currentTarget.dataset.tab
  }

  activeValueChanged(value) {
    this.tabTargets.forEach(tab => {
      tab.style.backgroundColor = tab.dataset.tab === value ? "#534AB7" : "#1a1a2e"
    })

    this.panelTargets.forEach(panel => {
      panel.hidden = panel.dataset.panel !== value
    })
  }
}
