import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="edit-prices"

// 1. The stimulus data-controller is on the admin.html.erb file
// 2. Targets on the span with the prices and on the form
// 3. Action click to toggle d-none classes
// 4. Action submit on the form

export default class extends Controller {
  static targets = ["priceSemaine", "priceWeekEnd", "priceHoliday", "priceCharge","form", "formSemaine", "formHoliday", "formCharge"]

  displayFormSemaine() {
    this.priceSemaineTarget.classList.add("d-none")
    this.formSemaineTarget.classList.remove("d-none")
  }

  displayFormWeekEnd() {
    this.priceWeekEndTarget.classList.add("d-none")
    this.formTarget.classList.remove("d-none")
  }

  displayFormHoliday() {
    this.priceHolidayTarget.classList.add("d-none")
    this.formTarget.classList.remove("d-none")
  }

  displayFormCharge() {
    this.priceChargeTarget.classList.add("d-none")
    this.formTarget.classList.remove("d-none")
  }

  update() {
    const url = this.formTarget.action 
    console.log(url)
    fetch(url, { method: "PATCH", headers: { "Accept": "text/plain" }, body: new FormData(this.formTarget) })
  }
}
