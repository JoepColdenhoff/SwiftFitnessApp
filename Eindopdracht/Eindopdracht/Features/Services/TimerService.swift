import Foundation
import SwiftUI

// ObservableObject allows a class to be observed by SwiftUI views.
// Combined with @Published, it enables reactive UI updates. Publishes timer state changes (isRunning, elapsedTime).
class TimerService: ObservableObject {
    // Marks a property as observable. When its value changes, SwiftUI views that reference the enclosing ObservableObject automatically update.
    // Updates the UI when the timer starts/stops.
    @Published var isRunning: Bool = false
    @Published var elapsedTime: TimeInterval = 0
    
    private var timer: Timer?
    private var startTime: TimeInterval = 0
    
    func start() {
        guard !isRunning else { return }
        isRunning = true
        startTime = Date().timeIntervalSince1970
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in // [weak self]: Prevents memory leaks by avoiding strong references in async closures.
            guard let self = self else { return }
            self.elapsedTime = Date().timeIntervalSince1970 - self.startTime
        }
    }
    
    func stop() {
        guard isRunning else { return }
        timer?.invalidate()
        timer = nil
        isRunning = false
    }
    
    func reset() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        elapsedTime = 0
        startTime = 0
    }
    
    var formattedTime: String {
        let totalSeconds = Int(elapsedTime)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
