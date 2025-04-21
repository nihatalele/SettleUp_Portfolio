# cse3901-2025sp-giles-BANDProject6

This project uses Ruby on Rails to create an application for organizing and handling the expenses for multi-day trip for a group of people.

## How to Run Application

1) Run "bundle install" in the terminal to install all the necessary gems in the Gemfile
2) Run "rails db:migrate" in the terminal
3) Run "rails server" in the terminal to start the application
4) Follow the link provided as a result in the terminal

## File Structure

Gemfile: Specifies the source and dependencies
Gemfile.lock: Automatically generated from bundle install
config/routes.rb: All app routes are defined here  
app/controllers/: Contains all controllers
app/views/: Contains views corresponding to each controller  
app/models/: Contains model definitions and associations  
db/migrate/: Contains all migration files used to modify the database schema  
app/views/devise/: Devise-generated views for authentication

## Team Members and Controller Contributions

Niha Talele: Contributed by scoping all trip, participant, and expense lookups through Trip.for_user(current_user) and added authorize_trip! before_actions in the Trips, Participants, and Expenses Controllers to enforce access by owner or invited email. Also updated the ParticipantsController to accept and validate an email field, enabling secure share‑by‑email functionality.

Aanya Tummalapalli: Contributed to enhancing the controller logic for currency conversion, totals calculation, and dynamic data display in trips_controller.rb and expenses_controller.rb.

Brandon Jiang: Contributed to creating the trips and participants controller and the destroy methods in trips_controller.rb, participants_controller.rb, and expenses_controller.rb.

Hyunsuk Hwang: Contributed creating the expenses function and the login/authentication function.
