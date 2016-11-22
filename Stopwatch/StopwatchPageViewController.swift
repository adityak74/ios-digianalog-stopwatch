//
//  StopwatchPageViewController.swift
//  Stopwatch
//
//  Created by Aditya Karnam Gururaj Rao on 11/20/16.
//  Copyright © 2016 David Vaughn. All rights reserved.
//

import UIKit

protocol NotificationProtocol {
    func timerUpdated(to timeStamp: TimeInterval)
    func lapUpdated(with timestamp: TimeInterval)
    func resetViewToDefault()
}

protocol StopwatchPageControlDelegate : class {
    func stopwatchPageViewController(stopwatchPageViewController: StopwatchPageViewController,
                                    didUpdatePageCount count: Int)
    
    func stopwatchPageViewController(stopwatchPageViewController: StopwatchPageViewController,
                                    didUpdatePageIndex index: Int)
}

class StopwatchPageViewController: UIPageViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate,MainViewToStopwatchPageViewNotificationProtocol {

    weak var stopwatchPageControlDelegate: StopwatchPageControlDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        stopwatchPageControlDelegate?.stopwatchPageViewController(stopwatchPageViewController: self, didUpdatePageCount: orderedViewControllers.count)
        
    }
    
    func lapUpdated(with timestamp: TimeInterval) {
        childViewControllers.forEach { (controller) in
            if let notificationController = controller as? NotificationProtocol {
                notificationController.lapUpdated(with: timestamp)
            }
        }
    }
    
    func timerUpdated(to timestamp: TimeInterval) {
        childViewControllers.forEach { (controller) in
            if let notificationController = controller as? NotificationProtocol {
                notificationController.timerUpdated(to: timestamp)
            }
        }
    }
    
    func resetViewToDefault() {
        childViewControllers.forEach { (controller) in
            if let notificationController = controller as? NotificationProtocol {
                notificationController.resetViewToDefault()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let firstViewController = viewControllers?.first,
            let index = orderedViewControllers.index(of: firstViewController) {
            stopwatchPageControlDelegate?.stopwatchPageViewController(stopwatchPageViewController: self, didUpdatePageIndex: index)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newColoredViewController(clockType: "DigitalClock"),
                self.newColoredViewController(clockType: "AnalogClock")]
    }()
    
    private func newColoredViewController(clockType: String) -> UIViewController {
        let vc =  UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "\(clockType)ViewController")
        return vc
    }
    
    @nonobjc func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    private func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = orderedViewControllers.index(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }

}
