import { Controller } from "@hotwired/stimulus"

// Explicit rendering keeps Turnstile working when Turbo replaces the form.
export default class extends Controller {
  static values = {
    siteKey: String,
    action: String,
  }

  connect() {
    this.waitForTurnstile()
  }

  disconnect() {
    window.clearTimeout(this.retryTimer)
    this.resizeObserver?.disconnect()

    if (this.widgetId !== undefined && window.turnstile) {
      window.turnstile.remove(this.widgetId)
    }
    this.widgetId = undefined
  }

  waitForTurnstile(attempt = 0) {
    if (window.turnstile?.render) {
      this.renderWidget()
      this.resizeObserver = new ResizeObserver(() => this.renderWidget())
      this.resizeObserver.observe(this.element)
      return
    }

    if (attempt < 100) {
      this.retryTimer = window.setTimeout(
        () => this.waitForTurnstile(attempt + 1),
        100,
      )
    }
  }

  renderWidget() {
    // The flexible widget requires 300px; compact fits small phone forms.
    const size = this.element.clientWidth < 300 ? "compact" : "flexible"
    if (this.widgetId !== undefined && this.widgetSize === size) return

    if (this.widgetId !== undefined) window.turnstile.remove(this.widgetId)
    this.widgetSize = size
    this.widgetId = window.turnstile.render(this.element, {
      sitekey: this.siteKeyValue,
      action: this.actionValue,
      theme: "light",
      size,
      language: "fr",
    })
  }
}
