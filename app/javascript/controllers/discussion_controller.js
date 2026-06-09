import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["textarea", "parentId", "replyBanner", "replyingTo"]

  connect() {
    this.currentMenu = null
    this.holdTimer   = null
    this.holdEl      = null
    this.holdOrigin  = { x: 0, y: 0 }
    this.#ensureSlideUpKeyframe()
  }

  disconnect() {
    clearTimeout(this.holdTimer)
    this.#removeMenu()
  }

  // ─── Long-press ──────────────────────────────────────────────────────────

  holdStart(event) {
    if (event.pointerType === "mouse" && event.button !== 0) return
    this.holdOrigin = { x: event.clientX, y: event.clientY }
    this.holdEl = event.currentTarget
    this.holdTimer = setTimeout(() => this.#fireHold(), 500)
  }

  holdEnd() {
    clearTimeout(this.holdTimer)
    this.holdTimer = null
  }

  holdMove(event) {
    if (!this.holdTimer) return
    const dx = Math.abs(event.clientX - this.holdOrigin.x)
    const dy = Math.abs(event.clientY - this.holdOrigin.y)
    if (dx > 8 || dy > 8) {
      clearTimeout(this.holdTimer)
      this.holdTimer = null
    }
  }

  #fireHold() {
    this.holdTimer = null
    const uid = document.body.dataset.currentUserId
    if (!uid || this.holdEl?.dataset.authorId !== uid) return
    if (navigator.vibrate) navigator.vibrate(40)
    this.#showDeleteSheet(this.holdEl)
  }

  #showDeleteSheet(commentEl) {
    this.#removeMenu()

    const backdrop = document.createElement("div")
    backdrop.style.cssText =
      "position:fixed;inset:0;z-index:9000;background:rgba(0,0,0,0.55);" +
      "display:flex;align-items:flex-end;justify-content:center;"

    const sheet = document.createElement("div")
    sheet.style.cssText =
      "width:100%;max-width:540px;" +
      "background:rgba(9,18,44,0.97);" +
      "backdrop-filter:blur(18px);-webkit-backdrop-filter:blur(18px);" +
      "border:1px solid rgba(255,255,255,0.08);" +
      "border-bottom:none;" +
      "border-radius:18px 18px 0 0;padding:20px 16px 40px;" +
      "display:flex;flex-direction:column;gap:10px;" +
      "animation:discussionSlideUp 0.22s ease;"

    const label = document.createElement("p")
    label.textContent = "Comment options"
    label.style.cssText =
      "font-size:0.75rem;color:rgba(255,255,255,0.3);text-align:center;margin:0 0 4px;"

    const delBtn = document.createElement("button")
    delBtn.className = "btn w-100"
    delBtn.style.cssText =
      "background:#FF204E;color:white;font-weight:600;" +
      "border-radius:10px;font-size:0.9rem;padding:12px;"
    delBtn.innerHTML = '<i class="fas fa-trash-alt me-2"></i>Delete comment'
    delBtn.addEventListener("click", () => {
      const form = commentEl.querySelector(".comment-delete-form")
      if (form) form.requestSubmit()
      this.#removeMenu()
    })

    const cancelBtn = document.createElement("button")
    cancelBtn.className = "btn w-100"
    cancelBtn.style.cssText =
      "background:rgba(255,255,255,0.07);color:white;" +
      "border-radius:10px;font-size:0.9rem;padding:12px;"
    cancelBtn.textContent = "Cancel"
    cancelBtn.addEventListener("click", () => this.#removeMenu())

    sheet.append(label, delBtn, cancelBtn)
    backdrop.appendChild(sheet)
    backdrop.addEventListener("click", e => {
      if (e.target === backdrop) this.#removeMenu()
    })

    document.body.appendChild(backdrop)
    this.currentMenu = backdrop
  }

  #removeMenu() {
    this.currentMenu?.remove()
    this.currentMenu = null
  }

  #ensureSlideUpKeyframe() {
    if (document.getElementById("discussion-slide-up-kf")) return
    const s = document.createElement("style")
    s.id = "discussion-slide-up-kf"
    s.textContent =
      "@keyframes discussionSlideUp{from{transform:translateY(100%)}to{transform:translateY(0)}}"
    document.head.appendChild(s)
  }

  // ─── Reply ───────────────────────────────────────────────────────────────

  startReply(event) {
    const btn      = event.currentTarget
    const username = btn.dataset.username
    const id       = btn.dataset.commentId

    this.parentIdTarget.value         = id
    this.textareaTarget.value         = `@${username} `
    this.replyingToTarget.textContent = `Replying to @${username}`
    this.replyBannerTarget.classList.remove("d-none")
    this.replyBannerTarget.classList.add("d-flex")
    this.textareaTarget.focus()

    const len = this.textareaTarget.value.length
    this.textareaTarget.setSelectionRange(len, len)
    this.textareaTarget.scrollIntoView({ behavior: "smooth", block: "nearest" })
  }

  cancelReply() {
    this.parentIdTarget.value = ""
    this.textareaTarget.value = ""
    this.replyBannerTarget.classList.add("d-none")
    this.replyBannerTarget.classList.remove("d-flex")
  }

  afterSubmit(event) {
    if (!event.detail.success) return
    this.textareaTarget.value = ""
    this.parentIdTarget.value = ""
    if (this.hasReplyBannerTarget) {
      this.replyBannerTarget.classList.add("d-none")
      this.replyBannerTarget.classList.remove("d-flex")
    }
  }
}
