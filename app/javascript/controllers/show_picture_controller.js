import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="show-picture"
export default class extends Controller {
  static targets = ["modal", "arrow", "pictures"]

  changePicture(event){
    const targets = this.picturesTargets
    const currentPicture = document.getElementById(`modal-photo`)
    let changePicture
    const classLisst = event.currentTarget.classList
    const index = targets.indexOf(currentPicture);
    if(classLisst.contains("arrow-left")){
      changePicture = targets[index - 1] || targets[targets.length - 1] // If it's the first picture, go to the last one
    }
    else if(classLisst.contains("arrow-right")){
      changePicture = targets[index + 1] || targets[0] // If it's the last picture, go to the first one
    }
    const modal = this.modalTarget

    if (changePicture){
      this.#setPictureSrc(modal, changePicture)
    }
  }
  showPictureWithoutArrow(event){

  }

  showPicture(event){
    console.log("Picture clicked")
    const picture = event.currentTarget
    const modal = this.modalTarget
    this.#setPictureSrc(modal, picture)
  }

  #setPictureSrc(modal, picture) {
    modal.querySelector(".modal-content")?.remove() // Remove any existing modal
    document.getElementById("modal-photo")?.removeAttribute('id') // Remove any existing modal photo
    
    modal.innerHTML += `<div class="modal-content"><img src="${picture.src}" alt="${picture.alt}"></div>`
    modal.style.display = "flex"
    picture.id = "modal-photo" // Set the id of the picture to modal-photo
    modal.querySelector(".close").onclick = () => {
      modal.style.display = "none"
      modal.querySelector(".modal-content").remove()
    }
  }
    
}
