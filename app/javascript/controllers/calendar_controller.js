import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="calendar"
export default class extends Controller {
  static targets = ["previousUrl", "nextUrl", "calendar", "day", "dateForm", "startDate", "endDate", "submit", "displayPrice"]


  calculPrices(){
    const days = this.dayTargets.filter((day) => day.classList.contains("selected"))
    
    let price = 0
    let numberOfNights = 0
    
    if (days.length === 0){
      price = 0
      numberOfNights = 0
    }
    else {
      const startDate = Number(days[0].firstElementChild.innerText)
      const allDays = document.querySelectorAll(".selected ~ td:has( ~ .selected) ")

      price = startDate
      numberOfNights = 1 + allDays.length
      
      allDays.forEach((day) => price += Number(day.firstElementChild.innerText))
      if (allDays.length === 0){
        const message = "Nous n'acceptont pas les réservations de moins de 2 nuits"
      }
    }
    this.displayPriceTarget.innerText = `Prix estimé: ${price}€ pour ${numberOfNights} nuits`
  }


  // Get the calendar of the next/previous month and insert it to not have to reload the page
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
