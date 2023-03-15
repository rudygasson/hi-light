import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="edit-tag"
export default class extends Controller {
  static targets = ["form", "tagInfo"]
  connect() {
  }

  displayForm() {
    this.formTarget.classList.toggle("d-none");
  }

  update(event) {
    event.preventDefault()
    const url = this.formTarget.action
    fetch(url, {
      method: "PATCH",
      headers: { "Accept": "text/plain" },
      body: new FormData(this.formTarget)
    })
      .then(response => response.text())
      .then((data) => {
        this.tagInfoTarget.outerHTML = data
        this.formTarget.classList.add("d-none");
      })
  }
}
