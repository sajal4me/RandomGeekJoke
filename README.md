# RandomGeekJoke

## Preview  
<img src=https://github.com/sajal4me/RandomGeekJoke/assets/17638808/f867e4ee-eccf-4472-80a5-cf1baa27de3a width="350" />   

<img src=https://github.com/sajal4me/RandomGeekJoke/assets/17638808/5644ade5-778a-4f70-a726-66bcb4d7a77e width="350" />

<img src=https://github.com/sajal4me/RandomGeekJoke/assets/17638808/00f4d9d0-7325-4c5c-8189-8b7cd133bfba width="350" />

## Summary
1. **RandomGeekJoke** is an iOS mobile application developed using the Swift programming language.

2. The app utilizes Core Data, a framework that guarantees the persistence of data across sessions.

3. The primary functionality of the app revolves around fetching a joke from an accessible API (https://geek-jokes.sameerkumar.website/api) at intervals of one minute. This process is indicated by a circular loader located in the top right corner of the app's interface. The loader completes its cycle in 1 minute, signaling the app to fetch a new joke once the cycle is finished.

4. The application keeps track of a joke list, with a maximum capacity of 10 jokes. If this limit is surpassed, the oldest joke is removed from the database to make space for the new one, which is then added to the end of the list.

5. The app ensures the integrity and coherence of data each time it is launched, offering users a consistent experience.


## Architecture
This application follows the Model View Presenter Architecture


## How To run

1. Clone this repository 

2. open RandomGeekJoke.xcodeproj 
