import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="edit-tag"
export default class extends Controller {
  static targets = ["form"]
  connect() {
    console.log("hello")
  }

  displayForm() {
    console.log(this.formTarget.dataset.id)
    this.formTarget.classList.remove("d-none");
  }
}
