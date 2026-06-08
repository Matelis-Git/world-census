import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["question", "category", "country", "optionsList", "countryButton", "categoryButton"]

  selectCategory(event) {
    event.preventDefault()
    const value = event.currentTarget.dataset.value
    const label = event.currentTarget.textContent.trim()
    this.categoryTarget.value = value
    this.categoryButtonTarget.textContent = label
    this.handleCategoryChange(value)
  }

  handleCategoryChange(value) {
    const addBtn = this.element.querySelector("#add-option-btn")
    if (value === "law") {
      this.optionsListTarget.innerHTML = `
        <div class="d-flex gap-2 mb-2 poll-option-item">
          <input type="text" name="poll[poll_options_attributes][0][text]" class="form-control" value="For" readonly style="pointer-events: none; cursor: default;" />
        </div>
        <div class="d-flex gap-2 mb-2 poll-option-item">
          <input type="text" name="poll[poll_options_attributes][1][text]" class="form-control" value="Against" readonly style="pointer-events: none; cursor: default;" />
        </div>
        <div class="d-flex gap-2 mb-2 poll-option-item">
          <input type="text" name="poll[poll_options_attributes][2][text]" class="form-control" value="Abstain" readonly style="pointer-events: none; cursor: default;" />
        </div>
      `
      if (addBtn) addBtn.style.display = "none"
    } else {
      this.optionsListTarget.innerHTML = `
        <div class="d-flex gap-2 mb-2 poll-option-item">
          <input type="text" name="poll[poll_options_attributes][0][text]" class="form-control" placeholder="Option" maxlength="50" />
          <button type="button" class="btn btn-outline-danger btn-sm align-self-center" data-action="click->poll-options#remove">✕</button>
        </div>
        <div class="d-flex gap-2 mb-2 poll-option-item">
          <input type="text" name="poll[poll_options_attributes][1][text]" class="form-control" placeholder="Option" maxlength="50" />
          <button type="button" class="btn btn-outline-danger btn-sm align-self-center" data-action="click->poll-options#remove">✕</button>
        </div>
      `
      if (addBtn) addBtn.style.display = ""
    }
  }

  selectCountry(event) {
    event.preventDefault()
    const value = event.currentTarget.dataset.value
    const label = event.currentTarget.textContent.trim()
    this.countryTarget.value = value
    this.countryButtonTarget.textContent = label
  }

  generateWithAI(event) {
    event.preventDefault()

    const question = this.questionTarget.value
    const category = this.categoryTarget.value
    const country = this.countryTarget.value

    const form = document.createElement("form")
    form.method = "POST"
    form.action = "/conversations"

    const csrfToken = document.querySelector('meta[name="csrf-token"]').content
    const fields = {
      authenticity_token: csrfToken,
      intent: "generate",
      "poll[title_question]": question,
      "poll[category]": category,
      "poll[country]": country
    }

    Object.entries(fields).forEach(([name, value]) => {
      const input = document.createElement("input")
      input.type = "hidden"
      input.name = name
      input.value = value
      form.appendChild(input)
    })

    document.body.appendChild(form)
    form.submit()
  }
}
