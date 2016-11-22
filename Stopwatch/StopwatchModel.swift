import Foundation

protocol StopwatchModelDelegate: class {
	func lapWasAdded()
	func timerUpdated(with timestamp: TimeInterval)
	func lapUpdated(with timestamp: TimeInterval)
	func updateLapResetButton(forState runningState: RunState)
	func updateStartStopButton(forState runningState: RunState)
	func resetDefaults()
}

extension StopwatchModelDelegate {
    func lapWasAdded() { }
    func timerUpdated(with timestamp: TimeInterval) { }
    func lapUpdated(with timestamp: TimeInterval) { }
    func updateLapResetButton(forState runningState: RunState) { }
    func updateStartStopButton(forState runningState: RunState) { }
    func resetDefaults() { }
}

class StopwatchModel {
	
	weak var delegate: StopwatchModelDelegate?
	fileprivate(set) var laps: [TimeInterval] = []
	fileprivate var timer: Timer?
	fileprivate var runState: RunState
	
	fileprivate var startTime: Date?
	fileprivate var lapStartTime: Date?
	fileprivate var masterTimeInterval: TimeInterval = 0
	fileprivate var lapTimeInterval: TimeInterval = 0
	
	init(delegate: StopwatchModelDelegate) {
		self.delegate = delegate
		runState = .reset
        let stopwatchPersistence = StopwatchPersistence()
        let lapTimes: [Double] = stopwatchPersistence.fetchLapsData()
        for lapTime in lapTimes {
            laps.append(lapTime)
        }
        
	}
	
	func lapResetPressed() {
		switch (runState) {
		case .started:
			addLap()
		case .stopped:
			runState = .reset
			invalidateTimer()
			delegate?.resetDefaults()
			return
		case .reset:
			break
		}
		
		delegate?.updateLapResetButton(forState: runState)
	}
	
	func startStopPressed() {
		switch (runState) {
		case .started:
			//Stop the timer
			if let startDate = startTime, let lapDate = lapStartTime {
				masterTimeInterval += Date().timeIntervalSince(startDate)
				lapTimeInterval += Date().timeIntervalSince(lapDate)
			}
			timer?.invalidate()
			runState = .stopped
		case .stopped:
			runState = .started
			fallthrough
		case .reset:
			startTime = Date()
			lapStartTime = startTime
			timer = Timer(timeInterval: 0.001, target: self, selector: #selector(StopwatchModel.updateTimeInterval(_:)), userInfo: nil, repeats: true)
			RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
			runState = .started
		}
		delegate?.updateStartStopButton(forState: runState)
		delegate?.updateLapResetButton(forState: runState)
	}
	
	fileprivate func addLap() {
		guard let lapTime = lapStartTime else {
			return
		}
		let value = Date().timeIntervalSince(lapTime)
		lapStartTime = Date()
		lapTimeInterval = 0
		laps.append(value)
        let stopwatchPersistence = StopwatchPersistence()
        stopwatchPersistence.storeLapData(lapNumber: laps.count, lapTimeInterval: value)
		delegate?.lapWasAdded()
		delegate?.lapUpdated(with: lapTimeInterval)
	}
	
	@objc func updateTimeInterval(_ timer: AnyObject) {
		guard let lapTime = lapStartTime,
			let watchTime = startTime else {
			return
		}
		let lapValue = Date().timeIntervalSince(lapTime) + lapTimeInterval
		let stopWatchValue = Date().timeIntervalSince(watchTime) + masterTimeInterval
		delegate?.lapUpdated(with: lapValue)
		delegate?.timerUpdated(with: stopWatchValue)
	}
	
	fileprivate func invalidateTimer() {
		timer?.invalidate()
		masterTimeInterval = 0
		lapTimeInterval = 0
		laps = []
        let stopwatchPersistence = StopwatchPersistence()
        stopwatchPersistence.deleteLapsData()
	}
}
