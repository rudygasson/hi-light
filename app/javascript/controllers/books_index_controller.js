import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="books-index"
export default class extends Controller {
  connect() {
    console.log("data-controller books-index is online")
  }

  metadata(event) {
    event.preventDefault()
    console.log("CLICK!")
  }

}
