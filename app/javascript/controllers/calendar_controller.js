import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="calendar"
export default class extends Controller {
  static targets = ["previousUrl", "nextUrl", "calendar"]

  previousMonth(){
    event.preventDefault()
    this.#fetching(this.previousUrlTarget.href)
  }

  nextMonth(){
    event.preventDefault()
    this.#fetching(this.nextUrlTarget.href)
  }


  #fetching(url){
    fetch(url, {
      method: "GET"
    })
      .then(response => response.text())
      .then((data) => {
        const parser = new DOMParser();
        const htmlDocument = parser.parseFromString(data, "text/html");
        const calendar = htmlDocument.documentElement.querySelector(".calendar-container");
        this.calendarTarget.replaceWith(calendar);
      })
  }

}
