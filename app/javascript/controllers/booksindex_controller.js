import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="booksindex"
export default class extends Controller {
  connect() {
    console.log("data-controller booksindex is online")
  }

  // TODO: implement AJAX book by book fetch with refresh
  // metadata() {
  //   console.log("CLICK!")
  //   fetch("http://localhost:3000/parse")

  // }

}
