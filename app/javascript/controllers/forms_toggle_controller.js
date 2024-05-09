import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form-toggle"
export default class extends Controller {
  static targets = ["form"]

  displayForm(){
    event.preventDefault()
    this.formTarget.classList.toggle("d-none")
  }
}
