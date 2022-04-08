# README

## Introduction ##

SAIFD Member Site is a website application that keeps track of peoples attendance to events scheduled by the officers or president. The events can be created and managed in this website by the admin/officers of the club. We also have announcements that will email the users for specific events or just everyone in general to be able to give updates to certain events or news.


## Requirements ##

This code has been run and tested on:

* Ruby - 3.0.2p107
* Rails - 6.1.4.1
* Ruby Gems - Listed in `Gemfile`
* PostgreSQL - 13.3 
* Nodejs - v16.9.1
* Yarn - 1.22.11


## External Deps  ##

* Docker - Download latest version at https://www.docker.com/products/docker-desktop
* Heroku CLI - Download latest version at https://devcenter.heroku.com/articles/heroku-cli
* Git - Downloat latest version at https://git-scm.com/book/en/v2/Getting-Started-Installing-Git

## Installation ##

Download this code repository by using git:

 `git clone https://github.com/TOneal419/SAIFD_Member_site.git`


## Tests ##

A Brakeman test can be ran by using:

  `brakeman/`

Rubocop tests can be ran by using:

  `rubocop/`

  `bundle exec rubocop <filename>` 
  

An RSpec test suite is available and can be ran using:

  `rspec spec/`

## Execute Code ##

Run the following code in Powershell if using windows or the terminal using Linux/Mac

  `cd your_github_here`

  `docker run --rm -it --volume "$(pwd):/csce431" -e DATABASE_USER=test_app -e DATABASE_PASSWORD=test_password -p 3000:3000 dmartinez05/ruby_rails_postgresql:latest`
  
  For windows replace $(pwd) -> ${PWD}


  `cd rails_app`

Install the app

  `bundle install && rails webpacker:install && rails db:create && db:migrate`

Run the app
  `rails server --binding:0.0.0.0`

The application can be seen using a browser and navigating to http://localhost:3000/

## Deployment ##

Pushing to staging should automatically create a MVP.


## CI/CD ##

For continuous integration/continuous deployment, the development followed a strict structure to ensure that CI/CD was met optimally. After each small feature was developed, tested, and reviewed on Github by a team member, that feature was merged from the respective dev branch onto a staging branch. The branch then performed automatic testing to ensure the quality of the product being merged. When the merge succeeded the tests, an automatic pipeline established on Heroku would automatically deploy the changes onto the website, making the changes visible to everyone.

## Support ##

Admins looking for support should first look at the application help page.
Users looking for help seek out assistance from the customer.
