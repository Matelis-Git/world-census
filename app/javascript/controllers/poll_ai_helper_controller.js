  import { Controller } from "@hotwired/stimulus"
  
  export default class extends Controller {
    static targets = ["question", "category", "country", "optionsList"]

  connect() {
    this.categoryTarget.addEventListener('change', (event) => {
      if (event.target.value !== "law") return
      this.optionsListTarget.innerHTML = `
        <div class="d-flex gap-2 mb-2 poll-option-item">
          <input type="text" name="poll[poll_options_attributes][0][text]" class="form-control" value="Pour" readonly />
        </div> 
        <div class="d-flex gap-2 mb-2 poll-option-item">
          <input type="text" name="poll[poll_options_attributes][1][text]" class="form-control" value="Contre" readonly />
        </div> 
        <div class="d-flex gap-2 mb-2 poll-option-item">
          <input type="text" name="poll[poll_options_attributes][2][text]" class="form-control" value="Abstention" readonly />
        </div> 
      `
    })
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
