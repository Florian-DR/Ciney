import { Controller } from "@hotwired/stimulus"

const CONSENT_COOKIE = "analytics_consent"
const CONSENT_DURATION = 60 * 60 * 24 * 180

export default class extends Controller {
  static targets = ["banner"]
  static values = { measurementId: String }

  connect() {
    if (this.consent === "accepted") {
      this.loadAnalytics()
    } else if (this.consent !== "refused") {
      this.showBanner()
    }
  }

  accept() {
    this.storeConsent("accepted")
    this.hideBanner()
    this.loadAnalytics()
  }

  refuse() {
    this.storeConsent("refused")
    if (this.measurementIdValue) {
      window[`ga-disable-${this.measurementIdValue}`] = true
    }
    this.removeAnalyticsCookies()
    this.hideBanner()
  }

  manage() {
    this.showBanner()
  }

  trackReservation(event) {
    if (this.consent !== "accepted" || typeof window.gtag !== "function") return

    window.gtag("event", "reservation_click", {
      emplacement: event.params.emplacement
    })
  }

  get consent() {
    const cookie = document.cookie
      .split("; ")
      .find((entry) => entry.startsWith(`${CONSENT_COOKIE}=`))

    return cookie?.split("=")[1]
  }

  storeConsent(value) {
    const secure = window.location.protocol === "https:" ? "; Secure" : ""
    document.cookie = `${CONSENT_COOKIE}=${value}; Path=/; Max-Age=${CONSENT_DURATION}; SameSite=Lax${secure}`
  }

  loadAnalytics() {
    if (!this.measurementIdValue) return

    window[`ga-disable-${this.measurementIdValue}`] = false

    if (window.cineyAnalyticsLoaded) return

    window.cineyAnalyticsLoaded = true
    window.dataLayer = window.dataLayer || []
    window.gtag = window.gtag || function() { window.dataLayer.push(arguments) }
    window.gtag("js", new Date())
    window.gtag("config", this.measurementIdValue)

    const script = document.createElement("script")
    script.async = true
    script.src = `https://www.googletagmanager.com/gtag/js?id=${encodeURIComponent(this.measurementIdValue)}`
    document.head.appendChild(script)
  }

  removeAnalyticsCookies() {
    const hostParts = window.location.hostname.split(".")
    const domains = [window.location.hostname]

    for (let index = 1; index < hostParts.length - 1; index += 1) {
      domains.push(`.${hostParts.slice(index).join(".")}`)
    }

    document.cookie
      .split(";")
      .map((cookie) => cookie.trim().split("=")[0])
      .filter((name) => name === "_ga" || name.startsWith("_ga_"))
      .forEach((name) => {
        document.cookie = `${name}=; Path=/; Max-Age=0; SameSite=Lax`
        domains.forEach((domain) => {
          document.cookie = `${name}=; Path=/; Domain=${domain}; Max-Age=0; SameSite=Lax`
        })
      })
  }

  showBanner() {
    this.bannerTarget.hidden = false
    this.bannerTarget.querySelector("button")?.focus()
  }

  hideBanner() {
    this.bannerTarget.hidden = true
  }
}
