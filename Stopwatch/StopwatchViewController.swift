import UIKit

protocol MainViewToStopwatchPageViewNotificationProtocol {
    func timerUpdated(to timeStamp: TimeInterval)
    func lapUpdated(with timestamp: TimeInterval)
    func resetViewToDefault()
}

class StopwatchViewController: UIViewController {

	@IBOutlet weak var lapMinutesLabel: UILabel!
	@IBOutlet weak var lapSecondsLabel: UILabel!
	@IBOutlet weak var lapMillisecondsLabel: UILabel!
	@IBOutlet weak var lapResetButton: ControlButtonView!
	@IBOutlet weak var startStopButton: ControlButtonView!
	@IBOutlet weak var lapsTableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControlButtons: UIPageControl!
	
	fileprivate(set) var model: StopwatchModel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		model = StopwatchModel(delegate: self)
		setupDefaults()
	}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let digitalAnalogPageViewController = segue.destination as? StopwatchPageViewController {
            digitalAnalogPageViewController.stopwatchPageControlDelegate = self
        }
    }
	
	func setupDefaults() {
		lapMinutesLabel.text = "00"
		lapSecondsLabel.text = "00"
		lapMillisecondsLabel.text = "00"
		lapResetButton.isEnabled = false
		lapResetButton.titleLabel.text = "Lap"
		startStopButton.titleLabel.text = "Start"
		lapsTableView.reloadData()
	}
    
    public func startStopBtPress() {
        model.startStopPressed()
    }

	@IBAction func lapResetButtonPressed(_ sender: AnyObject) {
		model.lapResetPressed()
	}
	
	@IBAction func startStopButtonPressed(_ sender: AnyObject) {
		model.startStopPressed()
		lapResetButton.isEnabled = true
	}
	
	fileprivate func formatTimeIntervalToString(_ time: TimeInterval) -> (minutes: String, seconds: String, milliseconds: String) {
		let minutes = (Int(time) / 60) % 60
		let seconds = Int(time) % 60
		let milliSeconds = Int(time * 100) % 100
		return (String(format: "%02d", minutes), String(format: "%02d", seconds), String(format: "%02d", milliSeconds))
	}
    
    
    
}

// MARK: - Table View DataSource Methods
extension StopwatchViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return model.laps.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var temp: [TimeInterval] = []
        if(model.laps.count>2){
            temp = model.laps
            temp.sort()
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Lap Cell", for: indexPath) as! LapCellTableViewCell
        
        let reverseIndex = model.laps.count - 1 - (indexPath as NSIndexPath).row
        let lap = model.laps[reverseIndex]
        
        //check the laps for best and worst
        if(temp.count>2){
            if(lap==temp[0]){
                cell.lapTimeLabel.textColor = UIColor.green
                cell.lapNumberLabel.textColor = UIColor.green
            }
            else if(lap==temp[temp.count-1]){
                cell.lapTimeLabel.textColor = UIColor.red
                cell.lapNumberLabel.textColor = UIColor.red
            }else {
                cell.lapTimeLabel.textColor = UIColor.white
                cell.lapNumberLabel.textColor = UIColor.white
            }
        }else{
            cell.lapTimeLabel.textColor = UIColor.white
            cell.lapNumberLabel.textColor = UIColor.white
        }
        let formatted = formatTimeIntervalToString(lap)
        cell.lapNumberLabel.text = "Lap \(reverseIndex + 1)"
        cell.lapTimeLabel.text = "\(formatted.minutes):\(formatted.seconds).\(formatted.milliseconds)"
        return cell
	}
}

// MARK: - Stopwatch Model Delegate Methods
extension StopwatchViewController: StopwatchModelDelegate {
	
	func lapWasAdded() {
		lapsTableView.reloadData()
	}
	
	func timerUpdated(with timestamp: TimeInterval) {
		//Update value of time in DigitalClockViewController
        childViewControllers.forEach { (controller) in
            if let stopwatchPageVC = controller as? MainViewToStopwatchPageViewNotificationProtocol {
                stopwatchPageVC.timerUpdated(to: timestamp)
            }
        }
	}
	
	func lapUpdated(with timestamp: TimeInterval) {
		let value = formatTimeIntervalToString(timestamp)
		lapMinutesLabel.text = value.minutes
		lapSecondsLabel.text = value.seconds
		lapMillisecondsLabel.text = value.milliseconds
        childViewControllers.forEach { (controller) in
            if let stopwatchPageVC = controller as? MainViewToStopwatchPageViewNotificationProtocol {
                stopwatchPageVC.lapUpdated(with: timestamp)
            }
        }
	}
	
	func updateLapResetButton(forState runningState: RunState) {
		switch (runningState) {
		case .stopped:
			lapResetButton.titleLabel.text = "Reset"
		case .started, .reset:
			lapResetButton.titleLabel.text = "Lap"
		}
	}
	
	func updateStartStopButton(forState runningState: RunState) {
		switch (runningState) {
		case .stopped, .reset:
			startStopButton.titleLabel.text = "Start"
			startStopButton.borderColor = UIColor.green
		case .started:
			startStopButton.titleLabel.text = "Stop"
			startStopButton.borderColor = UIColor.red
		}
	}
	
	func resetDefaults() {
		setupDefaults()
        childViewControllers.forEach { (controller) in
            if let stopwatchPageVC = controller as? MainViewToStopwatchPageViewNotificationProtocol {
                stopwatchPageVC.resetViewToDefault()
            }
        }
	}
}

// MARK: - StopwatchPageControl Delegate Methods
extension StopwatchViewController: StopwatchPageControlDelegate {
    
    func stopwatchPageViewController(stopwatchPageViewController: StopwatchPageViewController, didUpdatePageIndex index: Int) {
        pageControlButtons.currentPage = index
    }
    
    func stopwatchPageViewController(stopwatchPageViewController: StopwatchPageViewController, didUpdatePageCount count: Int) {
        pageControlButtons.numberOfPages = count
    }

}



