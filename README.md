# Google Event Management

## Overview
This is an event management system, which provides the ability to easily schedule, cancel or update any google calendar meetings using the app. It has a simple signup process using Google SSO ( OAuth 2.0 ).

[![Generic badge](https://img.shields.io/badge/Version-1.0-COLOR.svg)](https://github.com/blacklabel-dev/google-calendar-event-management/) ![Ruby](https://img.shields.io/badge/ruby-%23CC342D.svg?style=for-the-badge&logo=ruby&logoColor=white) ![Rails](https://img.shields.io/badge/rails-%23CC0000.svg?style=for-the-badge&logo=ruby-on-rails&logoColor=white) ![Postgres](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white) ![Heroku](https://img.shields.io/badge/heroku-%23430098.svg?style=for-the-badge&logo=heroku&logoColor=white) ![Google](https://img.shields.io/badge/google-4285F4?style=for-the-badge&logo=google&logoColor=white)

## Version Notes
- Ruby Version: v3.1.2 
- Rails Version: v7.0.1
- PostgreSQL: 13.2

## Database Architecture

- PostgreSQL is used as the app database.
- The database contains two tables
  1. User Table - It is responsible for storing user information.
  2. Event Table - It is responsible for storing event information.
- Schema ERD

|Event                          |User                                         |
|-------------------------------|---------------------------------------------|
|description _`text`_           |access_token _`string`_                      |
|end_at _`datetime(6,0) *`_     |avatar_url _`string`_                        |
|gc_event_id _`string`_         |email _`string`_                             |
|gc_link _`string`_             |expires_at _`string`_                        |
|location _`string`_            |full_name _`string`_                         |
|start_at _`datetime(6,0) *`_   |provider _`string`_                          |
|                               |refresh_token _`string`_                     |
|                               |uid _`string`_                               |

## App Flow

- Users can sign in using Google SSO ( Oauth2 ). During sign in, the user is asked to accept the consent and allow google calendar permission ( that can be used by the app later on )
- All events are listed in tabular form ( if any ) with the ability to edit and delete. Also, users have the ability to create new events. 
- Creating new events in the app, will also execute the Google Calendar API and register the same event in the user’s google calendar with EST timezone. 
- Similarly, events can be updated from the app and can be deleted, which will reflect in the user’s google calendar. 
- The app also provides the option to search the events based on the start and end date of the event. 


## Configuration and Implementation

- In order to use the Google SSO and Google Calendar API, we need to register a new app on the google cloud console. The process is as follows: 
  1. Navigate to - google cloud console
  2. Create a new app with basic information and a logo and publish the app for review.
  3. Create OAuth 2.0 credentials from - create credentials and select Web App. 
  4. You will get client_id and cliend_secret and add the redirect URI to the app.
  5. The credentials are being used in the app, using Rails credentials flow.

- Using the above credentials following google APIs are implemented.
   1. [Create Event](https://developers.google.com/calendar/api/v3/reference/events/insert)
   2. [Update Event](https://developers.google.com/calendar/api/v3/reference/events/update)
   3. [Delete Event](https://developers.google.com/calendar/api/v3/reference/events/delete)
 
 - Once the event is created the app stores the google calendar event id in the database, that is being used for updating and deleting APIs. 

- Heroku Configuration: [https://devcenter.heroku.com/articles/getting-started-with-rails7](https://devcenter.heroku.com/articles/getting-started-with-rails7)