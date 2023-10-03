import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="edit-prices"
export default class extends Controller {
  static targets = ["priceSemaine","priceWeekEnd", "form", "formSemaine"]

  connect() {
    console.log("hello")
  }

  displayFormSemaine() {
    console.log("semaine")
    this.priceSemaineTarget.classList.add("d-none")
    this.formSemaineTarget.classList.remove("d-none")
  }

  displayFormWeekEnd() {
    console.log("week-end")
    this.priceWeekEndTarget.classList.add("d-none")
    this.formTarget.classList.remove("d-none")
  }

  update() {
    // event.preventDefault()
    const url = this.formTarget.action
    console.log(this.formTarget)
    console.log(this.formTarget.action)
    fetch(url, { method: "PATCH", headers: { "Accept": "text/plain" }, body: new FormData(this.formTarget) })
  }
}
