// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application"

// Lazy load controllers as they appear in the DOM.
// This avoids loading every controller on every page and improves first load.
import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
lazyLoadControllersFrom("controllers", application)

// Eager loading is disabled to reduce initial JS work.
// import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
// eagerLoadControllersFrom("controllers", application)
