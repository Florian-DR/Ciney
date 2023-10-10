import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="calendar"
export default class extends Controller {
  static targets = ["previousUrl", "nextUrl", "calendar", "day", "displayPrice"]


  // Calculing, displaying the price and the message
  calculPrices(){
    const selectedDays = this.dayTargets.filter((day) => day.classList.contains("selected"))

    let price = 0
    let numberOfNights = 0
    let message = ""
    
    if (selectedDays.length !== 0){

      const startDatePrice = Number(selectedDays[0].firstElementChild.innerText)
      const bookingsDays = this.calendarTarget.querySelectorAll(".selected ~ td:has( ~ .selected) ")

      price = startDatePrice
      numberOfNights = 1 + bookingsDays.length 
      
      bookingsDays.forEach((day) => price += Number(day.firstElementChild.innerText))
      
      if(bookingsDays.length === 0){ message = "Nous n'acceptont pas les réservations de moins de 2 nuits. \n" }
    }

    if(isNaN(price)){this.displayPriceTarget.innerText = "Les prix ne sont pas encore défini pour ces dates."}
    else{this.displayPriceTarget.innerText = `Prix estimé: ${price}€ pour ${numberOfNights} nuits \n ` + message}

    
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
