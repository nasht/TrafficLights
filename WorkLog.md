*1pm : Started working on the estimate.*

* Knocked together a quick trial of the timer class on the main run loop. Tried playground, but runLoop didnt’ work, tried single View app

* UI / Storyboard Implementation 3 /4 hours

* Reusable light block - embedded UI Controller (1 hour) + segue

2pm : Started to work on the estimation notes below.

* Core App Logic

* Timer Logic - 2 - 3 hours

* Allowing time for idiosynchrcies with runLoop and timing.
* How crucial is it that the 30second rule is rock solid. Need to understand how runLoop and thread priority impact the actual timing.

* Light Coordinator - 2 - 4 hours

* Notes:

* Introduced this to ensure trafic lights do not know of one another.
* Consider how to handle logic for left turn / right turn lights also.
* May be useful for this to be a singleton - but would reconsider a factory if we have a more complex set of light changes to manage.

* Structure

* RedLights
* GreenLights
* init (north, south, east, west)
* run()

* init north south lights to red
* init eastWestLights to green.
* start a repeating timer that goes for 30 seconds.

* start a single timer that goes for 25 seconds.

* for each light that’s green, transition it to yellow.

* for each light that’s red, transition it to green.

* Traffic Light Object

* notes:

* this is ultimately a ViewModel object which doesn’t store any logic. Transitioning from one light to the next is the sole responsiblity of the controller.

* struct for current state
* get current state
* transitionTo(state)

* Notification Center - 1 hour
* GCD for timer operations.

* Unit Tests (+ refactoring for testability) - 3 - 4 hours

* Allowing an hour to figure out what is useful/testable in this instance.
* I’m purposely ignoring UI tests (as I’ve not done them before)

*2.20pm , started to work on a prototype to validate my thinking.*

- Realised I’d forgotten the syntax of Enums

*2.30pm: Stopped work on this. (renovation called)*

*2.52: Continued work again*

*15:00 stopped*

*15:30 started working again*

- I started working using the controller approach but it became apparent that the logic for handling the light switch would become quite inelegant to implement.

15:40: I’m investingation the possiblity to pass in the “transition time, and next state” to the light and have it manage it’s own timers.

16:00: Realised the above approach is not ideal either, and settled on a repeating 5 second timer which checks if we’re at 25 sec, or at 0 secs and alters the state of the lights appropreately.

16:30 stopped work 

20:40 started again (estimating)

Opened the supplied Test xcode project (earlier tody I was in my empty apartment working on a disconeccted laptop (instructions came from phone)

- Created an autolayout configuration for the lights.

- Looked up Swift dictionary literal syntax 

- Updated my controller to use a dictionary with an enum of directions to represent the light state

21:00 - Learned about swift typeLiterals :). 

21:39 - First run of the logic. NSNotification is not delivering the payload of trafflic light states correctly. Debugging.

22:00 - Figured out that NSNotification user Info was not being correctly set.

22:30 - As I'd been working on a newer version of Xcode for my test code, I had to refactor my TrafficLightController from a static/singleton to an instance (in order to support #selectors)

22:50 - Added a "second" counter and extracted the NSNotification publish to an EventUtils Class

23:00 - Working app. Git Repo configured. Readme updated.

23:10 - Todos for tomorrow - figure out what makes sense to unit test & add unit tests. Think about alternative approaches.

23:45 - A quick fix to contraints to make sure the app looks good on iPhone 5 as well, and I head off to bed.
