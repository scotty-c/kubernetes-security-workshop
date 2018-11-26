# Web App
scottyc/webapp

## The architecture
This is a demo webapp written in go that uses the native golang http server then serves a basic html page that listens on port 3000.

## Building 
Build locally `docker build -t scottyc/webapp .`
or use pre built image `docker pull scottyc/webapp`

## Running 
To run the app `docker run -d --name webapp -p 3000:3000 scottyc/webapp`