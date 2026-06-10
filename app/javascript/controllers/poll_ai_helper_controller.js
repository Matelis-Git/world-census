import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["question", "category", "country", "optionsList", "countryButton", "categoryButton"]

  connect() {
    this.currentSheet = null
    this.#ensureKeyframes()
  }

  disconnect() {
    this.#removeSheet()
  }

  // ─── Category / Country selectors (unchanged) ────────────────────────────

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
          <input type="text" name="poll[poll_options_attributes][0][text]" class="form-control" value="For" readonly style="pointer-events:none;cursor:default;" />
        </div>
        <div class="d-flex gap-2 mb-2 poll-option-item">
          <input type="text" name="poll[poll_options_attributes][1][text]" class="form-control" value="Against" readonly style="pointer-events:none;cursor:default;" />
        </div>
        <div class="d-flex gap-2 mb-2 poll-option-item">
          <input type="text" name="poll[poll_options_attributes][2][text]" class="form-control" value="Abstain" readonly style="pointer-events:none;cursor:default;" />
        </div>`
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
        </div>`
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

  // ─── AI Help popup ───────────────────────────────────────────────────────

  generateWithAI(event) {
    event.preventDefault()
    const question = this.questionTarget.value.trim()
    const category = this.categoryTarget.value
    const country  = this.countryTarget.value
    const options  = Array.from(
      this.optionsListTarget.querySelectorAll("input[type=text]")
    ).map(i => i.value.trim()).filter(Boolean)

    this.#showSheet()
    this.#fetchSuggestions({ question, category, country, options })
  }

  #showSheet() {
    this.#removeSheet()

    const backdrop = document.createElement("div")
    backdrop.style.cssText =
      "position:fixed;inset:0;z-index:9000;background:rgba(0,0,0,0.6);" +
      "display:flex;align-items:flex-end;justify-content:center;"

    const sheet = document.createElement("div")
    sheet.style.cssText =
      "width:100%;max-width:540px;min-height:62vh;max-height:88vh;" +
      "background:rgba(9,18,44,0.98);" +
      "backdrop-filter:blur(20px);-webkit-backdrop-filter:blur(20px);" +
      "border:1px solid rgba(255,255,255,0.09);border-bottom:none;" +
      "border-radius:22px 22px 0 0;padding:20px 16px 36px;" +
      "display:flex;flex-direction:column;gap:0;" +
      "overflow-y:auto;animation:aiSheetSlideUp 0.24s ease;"

    // Header
    const header = document.createElement("div")
    header.style.cssText = "display:flex;align-items:center;justify-content:space-between;margin-bottom:6px;"
    header.innerHTML = `
      <div>
        <p style="font-size:0.75rem;color:rgba(255,255,255,0.3);margin:0;">Census AI</p>
        <p style="font-size:1rem;font-weight:700;color:white;margin:0;">AI Poll suggestions</p>
      </div>
      <button id="ai-sheet-close" style="background:rgba(255,255,255,0.07);border:none;color:white;width:30px;height:30px;border-radius:50%;font-size:1rem;cursor:pointer;display:flex;align-items:center;justify-content:center;">✕</button>`

    const hint = document.createElement("p")
    hint.style.cssText = "font-size:0.77rem;color:rgba(207,226,255,0.35);margin:0 0 18px;"
    hint.textContent = "Tap a suggestion to autofill your poll"

    // Loading state
    const loadingEl = document.createElement("div")
    loadingEl.id = "ai-sheet-loading"
    loadingEl.style.cssText =
      "flex:1;display:flex;flex-direction:column;align-items:center;" +
      "justify-content:center;gap:12px;padding:32px 0;"
    loadingEl.innerHTML = `
      <div style="width:36px;height:36px;border:3px solid rgba(123,126,248,0.25);border-top-color:#7b7ef8;border-radius:50%;animation:aiSpin 0.8s linear infinite;"></div>
      <p style="font-size:0.83rem;color:rgba(207,226,255,0.4);margin:0;">Generating suggestions…</p>`

    const cardsEl = document.createElement("div")
    cardsEl.id = "ai-sheet-cards"
    cardsEl.style.cssText = "display:flex;flex-direction:column;gap:12px;"

    sheet.append(header, hint, loadingEl, cardsEl)
    backdrop.appendChild(sheet)

    backdrop.addEventListener("click", e => { if (e.target === backdrop) this.#removeSheet() })
    sheet.querySelector("#ai-sheet-close").addEventListener("click", () => this.#removeSheet())

    document.body.appendChild(backdrop)
    this.currentSheet = backdrop
  }

  async #fetchSuggestions({ question, category, country, options }) {
    try {
      const csrf = document.querySelector('meta[name="csrf-token"]').content
      const body = new URLSearchParams({ question, category, country })
      options.forEach(o => body.append("options[]", o))

      const res = await fetch("/polls/ai_suggestions", {
        method: "POST",
        headers: { "X-CSRF-Token": csrf, "Content-Type": "application/x-www-form-urlencoded" },
        body: body.toString()
      })
      const data = await res.json()
      if (data.error || !data.suggestions) throw new Error(data.error)
      this.#renderCards(data.suggestions)
    } catch {
      this.#renderError()
    }
  }

  #renderCards(suggestions) {
    if (!this.currentSheet) return
    const loading = this.currentSheet.querySelector("#ai-sheet-loading")
    const cards   = this.currentSheet.querySelector("#ai-sheet-cards")
    if (loading) loading.style.display = "none"

    const palette = ["#03C988", "#7b7ef8", "#FF7A2F"]

    suggestions.forEach((s, idx) => {
      const card = document.createElement("button")
      card.type = "button"
      card.style.cssText =
        "background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.09);" +
        "border-radius:16px;padding:14px;text-align:left;cursor:pointer;transition:background 0.15s;width:100%;"
      card.addEventListener("mouseenter", () => card.style.background = "rgba(255,255,255,0.08)")
      card.addEventListener("mouseleave", () => card.style.background = "rgba(255,255,255,0.04)")

      const accent = palette[idx % palette.length]
      const optionPills = (s.options || []).map(o =>
        `<span style="display:inline-block;background:rgba(255,255,255,0.07);border-radius:20px;padding:3px 10px;font-size:0.72rem;color:rgba(255,255,255,0.65);margin:3px 3px 0 0;">${o}</span>`
      ).join("")

      card.innerHTML = `
        <div style="display:flex;align-items:flex-start;gap:10px;">
          <span style="flex-shrink:0;width:22px;height:22px;border-radius:50%;background:${accent};display:flex;align-items:center;justify-content:center;font-size:0.7rem;font-weight:700;color:#000;margin-top:1px;">${idx + 1}</span>
          <div style="flex:1;min-width:0;">
            <p style="font-size:0.88rem;font-weight:700;color:rgba(255,255,255,0.92);margin:0 0 8px;line-height:1.35;">${s.question}</p>
            <div>${optionPills}</div>
          </div>
        </div>
        <div style="margin-top:12px;text-align:right;">
          <span style="font-size:0.75rem;font-weight:600;color:${accent};">Use this →</span>
        </div>`

      card.addEventListener("click", () => this.#autofill(s))
      cards.appendChild(card)
    })
  }

  #renderError() {
    if (!this.currentSheet) return
    const loading = this.currentSheet.querySelector("#ai-sheet-loading")
    if (loading) {
      loading.innerHTML = `<p style="font-size:0.83rem;color:rgba(255,120,120,0.8);text-align:center;">Could not generate suggestions — try again.</p>`
    }
  }

  #autofill(suggestion) {
    // Fill question
    this.questionTarget.value = suggestion.question

    // Fill options
    const opts = suggestion.options || []
    this.optionsListTarget.innerHTML = opts.map((opt, i) => `
      <div class="d-flex gap-2 mb-2 poll-option-item">
        <input type="text" name="poll[poll_options_attributes][${i}][text]"
               class="form-control" value="${opt.replace(/"/g, '&quot;')}" maxlength="50" />
        <button type="button" class="btn btn-outline-danger btn-sm align-self-center"
                data-action="click->poll-options#remove">✕</button>
      </div>`).join("")

    // Show add-option button
    const addBtn = this.element.querySelector("#add-option-btn")
    if (addBtn && this.categoryTarget.value !== "law") addBtn.style.display = ""

    this.#removeSheet()

    // Scroll to question field
    this.questionTarget.focus()
    this.questionTarget.scrollIntoView({ behavior: "smooth", block: "center" })
  }

  #removeSheet() {
    this.currentSheet?.remove()
    this.currentSheet = null
  }

  #ensureKeyframes() {
    if (document.getElementById("ai-sheet-kf")) return
    const s = document.createElement("style")
    s.id = "ai-sheet-kf"
    s.textContent = `
      @keyframes aiSheetSlideUp { from { transform: translateY(100%) } to { transform: translateY(0) } }
      @keyframes aiSpin { to { transform: rotate(360deg) } }
    `
    document.head.appendChild(s)
  }
}
