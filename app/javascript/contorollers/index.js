// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "@hotwired/stimulus"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-webpack-helpers"
eagerLoadControllersFrom("controllers", application)