# Settle Up

**Description:**  
Settle Up is a Ruby on Rails (MVC) web application for managing and sharing expenses on multi-day trips. Users can create trips, add participants, and securely split costs. Developed as a **collaborative class project**, with a focus on authentication, access control, and participant management.

---

## Key Features
- User authentication and secure login
- Create trips and manage participants
- Add and share expenses among friends
- Access control: users only see trips they own or are invited to

---

## My Contributions
- Scoped all trip, participant, and expense lookups using **ActiveRecord** (`Trip.for_user(current_user)`)
- Added `authorize_trip!` before_actions to enforce access control
- Updated participant functionality to accept and validate emails for secure expense sharing

---

## Tech Stack
Ruby on Rails, ActiveRecord, Devise (authentication), SQLite (development), HTML/CSS/ERB

---

## How to Run (Safe Version)
1. Clone the repo
2. Run `bundle install` to install dependencies
3. Run `rails db:migrate`
4. Run `rails server` and open the link provided in your terminal

---

## Team
Project developed collaboratively with three other students; I focused on security, access control, and participant management.

---

## Professor Feedback / Highlights
- Recognized for **well-structured Ruby code** and effective use of ActiveRecord for database interactions
- Appreciated **clear HTML/CSS styling**, including use of variables in stylesheets
- Noted for thoughtful **UI/UX choices**, such as participant summaries and the settle-up table
- Feedback helped improve **workflow intuitiveness** and design aesthetics

---

## Notes for Recruiters
This version uses **dummy data** and removes any sensitive information from the original project while demonstrating core functionality and my contributions.
