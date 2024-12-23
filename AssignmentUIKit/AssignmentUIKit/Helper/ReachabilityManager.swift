//
//  ReachabilityManager.swift
//  AssignmentUIKit
//
//  Created by Satish Rajpurohit on 23/12/24.
//

import Network

// This class utilizes Apple's `NWPathMonitor` to continuously monitor the network connection status and notifies the app when there are changes to the network's connectivity. It helps determine whether the device has an active internet connection and allows other parts of the app to react accordingly to network status changes.

class ReachabilityManager {
    
    static let shared = ReachabilityManager()
    
    private var monitor: NWPathMonitor?
    private var isConnected: Bool = false
    private var reachabilityHandler: ((Bool) -> Void)?
    
    private init() {
        // Setup the reachability monitor
        monitor = NWPathMonitor()
        
        // Monitor network status changes on a background queue
        let queue = DispatchQueue(label: "NetworkReachabilityQueue")
        monitor?.start(queue: queue)
        
        // Listen for network status changes
        monitor?.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            self?.reachabilityHandler?(self?.isConnected ?? false)
        }
    }
    
    // Call this to set up a listener that reacts to network status changes
    func setReachabilityHandler(_ handler: @escaping (Bool) -> Void) {
        self.reachabilityHandler = handler
        // Immediately call the handler with the current network status
        handler(isConnected)
    }
    
    // Call this method to get the current network status
    func isInternetAvailable() -> Bool {
        return isConnected
    }
    
    // Stop monitoring the network status
    func stopMonitoring() {
        monitor?.cancel()
    }
}
