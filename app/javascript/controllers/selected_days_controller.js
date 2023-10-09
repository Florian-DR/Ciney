import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="selected-days"
export default class extends Controller {
  static targets = ["day"]

  select(){
    this.dayTarget.classList.toggle("selected")
  }
}
