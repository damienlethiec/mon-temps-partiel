import { Controller } from "stimulus"
import { setCookie, getCookie } from "./utilities.js"

export default class extends Controller {
  static targets = [ "fields", "successMessage" ]

  connect() {
    this.cookieIsSet() ? this.showSuccessMessage() : null
  }

  onSuccess() {
    this.showSuccessMessage()

    setCookie(28, `_${this.data.get("siteName")}_subscribed_to_newsletter`, true)
  }

  showSuccessMessage() {
    this.fieldsTarget.classList.add('hidden')

    this.successMessageTarget.classList.remove('hidden')
  }

  cookieIsSet() {
    return getCookie(`_${this.data.get('siteName')}_subscribed_to_newsletter`)
  }
}

