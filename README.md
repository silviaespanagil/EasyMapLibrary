# EasyMapLibrary

EasyMapLibrary is a Swift library designed to simplify the use of maps in iOS applications. It provides a range of tools and components for handling user location, performing local searches, and displaying maps with annotations and circles.

## Features

- User location permission management.
- Continuous user location updates.
- Address and place search using `MKLocalSearchCompleter`.
- Map display with annotations and circles.
- Map camera interaction to focus on specific locations.

## Requirements

- iOS 17.0 or higher.
- Xcode 14 or higher.

## Installation

### Swift Package Manager (SPM)

To integrate `EasyMapLibrary` into your project using Swift Package Manager, add the following dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/EasyMapLibrary.git", from: "1.0.0")
]
```

Then add EasyMapLibrary to your target's dependencies:

```swift
.target(name: "YourTarget", dependencies: ["EasyMapLibrary"])
```

You can also go to XCode - Files - Add Package Dependencies and search the library with this link `https://github.com/silviaespanagil/EasyMapLibrary`

### Carthage

EasyMapLibrary is not yet compatible with Carthage. If you are interested in this option, consider contributing with a Pull Request.

## Usage

`EasyMapLibrary` has three main funcionalities that can be used independently depending on the needs of your project. Remember that in all cases you will have to `import EasyMapLibrary`

### LocationManager

The `LocationManager` class is responsible for managing and updating the user's location. It provides methods to request location permissions, start and stop location updates, and handle location updates through a delegate. It can be used independently to get the user's current location and track any changes.

To use the location manager, you must always call `.requestLocationPermission()` to be compliant with Apple Guidelines. Remember that you will need to update your project with `NSLocationWhenInUseUsageDescription` and `NSLocationAlwaysUsageDescription` with an explanation of why you need the user's location.

```swift
import EasyMapLibrary

@StateObject private var locationManager = LocationManager()

// Request permission and start updating location
locationManager.requestLocationPermission()
locationManager.startUpdatingLocation()
```

#### Methods

Here is a list of all available methods in the LocationManager class:

| Method                                          | Description                                                    |
|-------------------------------------------------|----------------------------------------------------------------|
| `requestLocationPermission()`                   | Requests permission to access the user's location.              |
| `startUpdatingLocation()`                       | Starts updating the user's location.                            |
| `stopUpdatingLocation()`                        | Stops updating the user's location.                             |
| `onLocationUpdate(handler: @escaping (CLLocationCoordinate2D) -> Void)` | Provides a closure to handle location updates.   |

### MapManager

The MapManager class handles map-related functionalities, including updating the map camera position, searching for addresses, suggesting addresses, and managing search results. It integrates with LocationManager to get the user's current location. The MapManager also takes a defaultLocation where your map will have the initial focus.


```swift
import EasyMapLibrary

let mapManager = MapManager(defaultLocation: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))

// Request permission
mapManager.requestLocationPermission()

// Update search query
mapManager.updateSearchQuery("San Francisco")
```
#### Methods
Here is a list of all available methods in the MapManager class:

| Method                                          | Description                                                    |
|-------------------------------------------------|----------------------------------------------------------------|
| `updateUserLocation(_ location: CLLocationCoordinate2D?)` | Updates the user's current location.                           |
| `updateSelectedCoordinate(_ coordinate: CLLocationCoordinate2D?)` | Updates the selected coordinate on the map.                    |
| `updateMapCameraPosition(_ position: MapCameraPosition)` | Updates the camera position of the map.                        |
| `setDefaultLocation(to coordinate: CLLocationCoordinate2D)` | Sets a default location for the map.                           |
| `requestLocationPermission()`                   | Requests permission to access the user's location.              |
| `updateSearchQuery(_ query: String)`             | Updates the search query for local search.                     |
| `search(_ completion: MKLocalSearchCompletion)`  | Initiates a search based on the provided completion result.    |
| `searchAddress(for coordinate: CLLocationCoordinate2D)` | Searches for an address based on a coordinate.                 |

### MapView

The MapView struct provides a SwiftUI view for displaying maps and integrating map-related functionalities such as location selection and address search. It wraps around MapKit's Map and other components to offer a seamless map viewing experience.

If `showSearchField` is set to true, users can input an address, and a sheet with address suggestions will appear at the bottom of the view. Users can click to confirm their selection.

```swift
import SwiftUI
import EasyMapLibrary

struct ContentView: View {
    @StateObject private var mapManager = MapManager(defaultLocation: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))

    var body: some View {
        MapView(mapManager: mapManager, showSearchField: true)
    }
}

```

## Videos
Here's how the map looks.

<img src="https://github.com/silviaespanagil/EasyMapLibrary/assets/81619759/010ddb8d-5ff2-4dc5-9bdf-9fb6ffb47622" alt="" width="250"/>

https://github.com/silviaespanagil/EasyMapLibrary/assets/81619759/b56a8dc5-b35d-4aa6-a076-08beff0e03fd
  
## Next updates
- Colour customization

Do you have any idea or request? Catch me in Twitter: @fischesil

## License
EasyMapLibrary is available under the MIT license. See the LICENSE file for more information.


