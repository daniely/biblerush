import '../stylesheets/application.scss'
import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

// for stimulus.js
const application = Application.start()
const context = require.context("./controllers", true, /\.js$/)
application.load(definitionsFromContext(context))

// Import and register TailwindCSS Components
import { Alert, Modal, Popover, Tabs } from "tailwindcss-stimulus-components"
application.register('alert', Alert)
application.register('modal', Modal)
application.register('popover', Popover)
application.register('tabs', Tabs)

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
