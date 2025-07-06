import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="show-picture"
export default class extends Controller {
  static targets = ["picture", "modal"]
  connect() {
    console.log("ShowPictureController connected")
    console.log(this.pictureTargets)
  }

  showPicture(){
    console.log("Picture clicked")
    const picture = event.currentTarget
    const modal = this.modalTarget
    modal.innerHTML += `<img src="${picture.src}" alt="${picture.alt}" class="modal-content">`
    modal.style.display = "block"
    modal.querySelector(".close").onclick = () => {
      modal.style.display = "none"
      modal.querySelector(".modal-content").remove()
    }
  }
}
