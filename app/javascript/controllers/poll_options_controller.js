import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["optionsList", "addButton"]

  connect() {
    this.updateAddButton()
  }

  add(event) {
    event.preventDefault()
    if (this.optionCount >= 4) return

    const index = new Date().getTime()
    const count = this.optionCount + 1
    const html = `
<div class="input-group gap-2 mb-2 poll-option-item">
 <input type="text" name="poll[poll_options_attributes][${index}][text]"
         class="form-control rounded-2" placeholder="Option ${count}" maxlength="50" />
  <button class="btn btn-outline-danger btn-sm align-self-center" type="button"
          data-action="click->poll-options#remove">✕</button>
      </div>
    `
    this.optionsListTarget.insertAdjacentHTML("beforeend", html)
    this.updateAddButton()
  }

  remove(event) {
    event.preventDefault()
    if (this.optionCount <= 2) return
    event.target.closest(".poll-option-item").remove()
    this.updateAddButton()
  }

  get optionCount() {
    return this.optionsListTarget.querySelectorAll(".poll-option-item").length
  }

  updateAddButton() {
    this.addButtonTarget.disabled = this.optionCount >= 4
  }
}
