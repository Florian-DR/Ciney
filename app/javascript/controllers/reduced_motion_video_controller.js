import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.motionPreference = window.matchMedia("(prefers-reduced-motion: reduce)")
    this.handleMotionChange = this.updatePlayback.bind(this)
    this.motionPreference.addEventListener("change", this.handleMotionChange)
    this.updatePlayback()
  }

  disconnect() {
    this.motionPreference?.removeEventListener("change", this.handleMotionChange)
  }

  updatePlayback() {
    if (this.motionPreference.matches) {
      this.element.pause()
      return
    }

    const playback = this.element.play()
    playback?.catch(() => {})
  }
}
