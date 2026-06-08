  import { Controller } from "@hotwired/stimulus"

  export default class extends Controller {
    static targets = ["question", "category", "country", "countryButton"]

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
