#  Belarusbank

Description
-----------

Developed an application that displays ATMs, infokiosks and filials of Belarusbank on the map and in the form of a list. 
Autolayout is performed with SnapKit. SwiftLint is connected. Dark and light application theme supported.
All downloaded objects are saved in CoreData so that the application works without internet connection. 
For each of the development options of the application it is extended with messages on the alert. 
There is a UISegmentedControl that switches between the card and the list. The map is selected by default.
Map displays points from coordinates of downloaded objects. For each type: ATM, infokiosk and bank made a custom picture 
of the output on the map. Clicking on the object shows a pop-up window with information on the map.
Clicking on the button “more details" opens a new controller on which all available information about the object is displayed.
At the bottom of the screen is the button "plote a route", which throws the user in the map installed on his phone, 
with a built route from the current location of the user to the object. Objects are displayed as a list of UICollectionView collections, 
grouped by city and sorted remotely from the current location or, if the location is not available, from the default point.
When you click the "update" button, the application sends a request to load objects from the network. 
The interface is locked until the list of ATMs is received.
Clicking on the "filtered" button displays a modal window on which the user 
selects the types of the object he wants to see in the list and on the map. All are selected by defaults.
On the first run, the application requests access to the user’s geolocation. If the user does not allow access, 
the application notifies the user at the next launches and recommends navigating to settings to enable geolocation.

APLIED
------
Applied: UIKit, MapKit, CoreLocation, Network, REST API, CollectionView and 
Scroll View, Custom annotation, Cocoapods(SnapKit), Homebrew(SwiftLint), UserDefaults, CoreData, GCD, MVC.

SCREENS
-------

https://user-images.githubusercontent.com/105222842/215354417-47177557-2125-4740-b437-7f031432c1c9.mp4
<img width="352" alt="Screenshot 2023-01-29 at 22 51 44" src="https://user-images.githubusercontent.com/105222842/215354289-fb0389ae-438e-498a-b98d-d0be6020eca4.png">
<img width="341" alt="Screenshot 2023-01-29 at 22 51 58" src="https://user-images.githubusercontent.com/105222842/215354288-52697768-7521-4a25-8d5e-5f6175408b9d.png">
<img width="346" alt="Screenshot 2023-01-29 at 22 52 18" src="https://user-images.githubusercontent.com/105222842/215354286-416eb2a7-23d7-4136-b178-79396679b503.png">
<img width="338" alt="Screenshot 2023-01-29 at 22 52 39" src="https://user-images.githubusercontent.com/105222842/215354285-ed516b6c-8917-4f00-9233-68482ff7d95a.png">
<img width="345" alt="Screenshot 2023-01-29 at 23 20 37" src="https://user-images.githubusercontent.com/105222842/215354283-1c2944a3-2883-4e40-8402-d40f11759001.png">
<img width="339" alt="Screenshot 2023-01-29 at 23 21 25" src="https://user-images.githubusercontent.com/105222842/215354280-da79deb6-b80b-4b0a-b4f3-802a8a8e0555.png">
<img width="349" alt="Screenshot 2023-01-29 at 23 24 02" src="https://user-images.githubusercontent.com/105222842/215354275-ed6d1d92-44f9-4388-a6fc-d571a743bf23.png">
