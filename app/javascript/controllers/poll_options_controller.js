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
      <div class="d-flex gap-2 mb-2 poll-option-item">
        <input type="text" name="poll[poll_options_attributes][${index}][text]"
               class="form-control" placeholder="Option ${count}" />
        <button class="btn btn-outline-danger btn-sm align-self-center"
                data-action="click->poll-options#remove" type="button">✕</button>
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
