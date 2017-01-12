### Traffic Light Solution:

This project implements a solution to the traffic light test as set out by SafetyCulture

## It features:

- AutoLayout configured view in Main.storyboard
- A start/stop toggle button
- A second counter (to pass the dull 25 seconds waiting for something to happen)
- Event Driven architecture to minimise the coupling between the UI and the unerlying implementation.

## Logic

The app is designed to be quite has simple as possible, with some view to possible extensiblity. 
TrafficLight state is managed in the model: TrafficLight. This is a dumb object that only exists to maintain state.
The TrafficLightController is the guts

## Limitations / Considerations
- While it can support an arbitrary number of lights, the solution in its current form does not take into account more complex logic for light changes. Eg: Denoting a priority set of lights which are alwys green, until a pedestrian or car is at the intersecting road.
    - This would require a refactor, where I could potentially use a queue of light states which is processed periodically. That way if a state change occurs, it is added to the queue, and processed in the next cycle. 
- More complex rules that capture interplay between lights, and subsequent validation of those rules (eg: LightX must never be Green when LightY is green) is obviously somethign to think about, but I've chosen to not take this path in order to complete the task in a reasonable amount of time. Happy to discuss possible approaches with the reviewer.
- The event driven approach needs to be carefuly managed as the app grows. I've chosen to have my controller notify all interested parties of changes in its state. Another approach could be to have the model notify changes, or indeed to abandon the Event driven approach and use callbacks or direct coupling (though I'm not a fan')
