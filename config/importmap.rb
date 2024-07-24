# config/importmap.rb

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "controllers", to: "controllers.js", preload: true
pin "rails-ujs", to: "rails-ujs.js", preload: true
pin "packs/bootstrap", to: "bootstrap.min.js", preload: true
pin "bootstrap", to: "bootstrap.min.js"
