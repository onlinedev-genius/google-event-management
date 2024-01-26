import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"

export default class extends Controller {
  connect() {
    this.config = {
      altInput: true,
      allowInput: true,
      enableTime: true
    }

    flatpickr('.datetimepicker', this.config)
  }
}
