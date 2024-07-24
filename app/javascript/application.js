// app/javascript/packs/application.js
//= require bootstrap
//= require order_form 
//= require jquery

import Rails from "@rails/ujs";
import "@hotwired/turbo-rails";
import "controllers";
import "bootstrap/dist/js/bootstrap.bundle.min";
import "bootstrap/dist/css/bootstrap.min.css";

Rails.start();

import * as bootstrap from "bootstrap"
