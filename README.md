# Project 2 - BeReal Clone

Submitted by: **Sophia Sartor**

**BeReal Clone** is an app that lets users sign up, log in, and post a photo from their photo library with a caption. Posts show up in a feed with the location and time the photo was taken.

Time spent: 6 hours spent in total

## Required Features

The following **required** functionality is completed:

- [x] Users see an app icon in the home screen and a styled launch screen.
- [x] User can register a new account
- [x] User can log in with newly created account
- [x] App has a feed of posts when user logs in
- [x] User can upload a new post which takes in a picture from photo library and an optional caption
- [x] User is able to logout

The following **optional** features are implemented:

- [x] Users can pull to refresh their feed and see a loading indicator
- [x] Users can infinite-scroll in their feed to see past the 10 most recent photos
- [x] Users can see location and time of photo upload in the feed
- [x] User stays logged in when app is closed and open again

The following **additional** features are implemented:

- [x] Location shows as a city and country name instead of coordinates
- [x] Older posts without photo info still show the date they were posted

## Video Walkthrough

https://youtu.be/zAbGGOHY5JA

## Notes

Getting the photo's location and time was the hardest part. I had to ask for photo library permission and use the photo's id to get its info. I also ran into a server error from Back4App once, but it worked again after a minute.

## License

    Copyright 2026 Sophia Sartor

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.