import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="display-toggle"
export default class extends Controller {
  static targets = ["toToggle"]

  toggleDisplay(){
    event.preventDefault()
    this.toToggleTarget.classList.toggle("d-none")
  }
}
