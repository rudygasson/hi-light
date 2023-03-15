import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="booksindex"
export default class extends Controller {
  connect() {
    console.log("data-controller booksindex is online")
  }

  metadata() {
    console.log("CLICK!")
  }

}
