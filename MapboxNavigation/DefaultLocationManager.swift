import Foundation
import MapboxCoreNavigation

/**
 `DefaultLocationManager` is a location manager that tracks the battery state and modifies the desired accuracy accordingly.
 */
open class DefaultLocationManager: NavigationLocationManager {
    
	override public init() {
        super.init()
        UIDevice.current.addObserver(self, forKeyPath: "batteryState", options: .initial, context: nil)
    }
    
	override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "batteryState" {
            let batteryState = UIDevice.current.batteryState
            let pluggedIn = batteryState == .charging || batteryState == .full
            desiredAccuracy = pluggedIn ? kCLLocationAccuracyBestForNavigation : kCLLocationAccuracyBest
        }
    }
    
    deinit {
        UIDevice.current.removeObserver(self, forKeyPath: "batteryState")
    }
}
