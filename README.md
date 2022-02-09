# soladis-music

A Rails6 website for music tracks and embedded YouTube-Videos: (https://soladis-music.net) 

It includes static pages as well as a content management system for users, music tracks and videos and is deployed via Heroku. 
Users can register for the website and after they activated their account they can log in and are redirected to their profile where they can add music tracks and videos. <br>
Every authenticated user can view all published tracks and edit and delete the own tracks and videos. An admin role can be assigned to a user. Admins can view, edit and delete all tracks and videos. 

# Usage
1. ```git clone https://github.com/BluePeony/soladis-music.git```
2. ```bundle install```
3. ```rails webpacker:install```
4. ```rails db:migrate```
