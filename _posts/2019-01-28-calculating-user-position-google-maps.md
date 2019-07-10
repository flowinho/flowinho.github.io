---
layout: post
title: "Calculating the on-screen user position in GoogleMapsService"
tags: code
---

So my UX colleague wanted to have a custom “My Position” button visible in a map-related project i’m currently working on. It offers context-aware functionality depending on wether the users position is currently visible on the screen or not. Here’s the solution i came up with.

## First problem: detecting camera movement

This problem is the less interesting of two problems i encountered. However i’d like to write it down for the sake of completeness.

The Google Maps SDK Documentation describes the delegate GMSMapViewDelegate which delivers the implementation we need. Specifically we will make us of it’s function `mapView:didChangeCameraPosition:`

The declaration inside the SDK:

```swift
/**
 * Called repeatedly during any animations or gestures on the map (or once, if the camera is
 * explicitly set). This may not be called for all intermediate camera positions. It is always
 * called for the final position of an animation or gesture.
 */
 /* Objective-C*/
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position;
/* Swift */
public func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition)
```

By assigning this delegate to our mapView we get the delegate callback we need to continue working on the initial problem:

```swift
extension MapVC: GMSMapViewDelegate {
    public func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        // Do something
    }
}
```

## The second problem: detecting wether the users position is visible in the current viewport

This is a slightly more complicated problem: a geoposition such as the position of the user is delivered in geocoordinates, in the case of the CocoaTouch CoreLocation module it is CLLocation.

However the viewport is pixel-based since it’s based on the screen of the user’s device. So we’ll need a way to transform world-coordinates to screen-coordinates.

This is where GMS Projection comes in very handy.

GMSProjection defines the function pointForCoordinate which is described as:

    Maps an Earth coordinate to a point coordinate in the map’s view.

This way, we are able to calculate the position of a real-world coordinate on the users screen. However we want to quickly determine wether the coordinate is off-screen so there is no need for the actual return value of pointForCoordinate.

```swift
import Foundation
import GoogleMaps

public protocol GMSHelper { }

extension GMSHelper {
    func locationIsVisible(inMap mapView: GMSMapView, forLocation location: CLLocationCoordinate2D) -> Bool {
        let point = mapView.projection.point(for: location)
        return mapView.isPointInsideBounds(point: point)
    }
}

extension UIView {
    func isPointInsideBounds(point: CGPoint) -> Bool {
        return point.x > 0 && point.y > 0 && point.x < self.bounds.width && point.y < self.bounds.height
    }
}
```

With this handy protocol, every type that adopts GMSHelper can call the `locationIsVisible(inMap:forLocation:)` method without further ado.

```swift
// Make sure to adopt GMSHelper to get access to it`s extension and default implementation
public class MapVC: UIViewController, GMSHelper {
    ...
}

// Use the newly created function to determine wether the users position is visible or not
extension MapVC: GMSMapViewDelegate {
    public func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let userIsInsideVisibleArea = locationIsVisible(inMap: mapView, forLocation: self.userLocation)
        if userIsInsideVisibleArea {
            // Do something
        }    
    }
}
```

Here we go. From this point onwards it’s pretty easy to react on camera movements.

I love protocol oriented programming in Swift <3
