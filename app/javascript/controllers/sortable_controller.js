import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

const list = document.querySelector("#results")

const initSortable = () => {
  Sortable.create(list)
}

// Connects to data-controller="sortable"
export default class extends Controller {
  connect() {
  }
}
