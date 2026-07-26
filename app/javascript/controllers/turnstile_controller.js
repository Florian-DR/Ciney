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

    if (this.widgetId !== undefined && window.turnstile) {
      window.turnstile.remove(this.widgetId)
    }
  }

  waitForTurnstile(attempt = 0) {
    if (window.turnstile?.render) {
      this.widgetId = window.turnstile.render(this.element, {
        sitekey: this.siteKeyValue,
        action: this.actionValue,
        theme: "light",
        size: "flexible",
        language: "fr",
      })
      return
    }

    if (attempt < 100) {
      this.retryTimer = window.setTimeout(
        () => this.waitForTurnstile(attempt + 1),
        100,
      )
    }
  }
}
