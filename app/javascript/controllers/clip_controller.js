import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clip"
export default class extends Controller {
  static targets = ["item"]
  connect() {
    console.log("hello")
  }

  copy() {
    console.log(this.element)
    navigator.clipboard.writeText(this.itemTarget.innerHTML)
  }
}
