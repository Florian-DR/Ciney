import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="video-autoplay"
export default class extends Controller {
  connect() {
    this.checkAndEnableAutoplay()
  }

  checkAndEnableAutoplay() {
    const video = this.element
    // Check if it's not a mobile device (screen width > 768px or not touch device)
    const isDesktop = window.innerWidth > 768 && !('ontouchstart' in window)

    if (isDesktop) {
      video.setAttribute('autoplay', 'autoplay')
      video.play().catch(function(error) {
        console.log('Autoplay failed:', error)
      })
    }
  }
}