import UIKit
import MapboxDirections
import MapboxCoreNavigation

protocol RoutePageViewControllerDelegate: class {
    var currentLeg: RouteLeg { get }
    var currentStep: RouteStep { get }
    var upComingStep: RouteStep? { get }
    func stepBefore(_ step: RouteStep) -> RouteStep?
    func stepAfter(_ step: RouteStep) -> RouteStep?
    func routePageViewController(_ controller: RoutePageViewController, willTransitionTo maneuverViewController: RouteManeuverViewController)
}

class RoutePageViewController: UIPageViewController {
    
    weak var maneuverDelegate: RoutePageViewControllerDelegate!
    var currentManeuverPage: RouteManeuverViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        view.clipsToBounds = false
        // Disable clipsToBounds on the hidden UIQueuingScrollView to render the shadows properly
        view.subviews.first?.clipsToBounds = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupRoutePageViewController()
    }
    
    func notifyDidReRoute() {
        setupRoutePageViewController()
    }
    
    func setupRoutePageViewController() {
        let step = maneuverDelegate.upComingStep ?? maneuverDelegate.currentStep
        let leg = maneuverDelegate.currentLeg
        let controller = routeManeuverViewController(with: step, leg: leg)!
        setViewControllers([controller], direction: .forward, animated: false, completion: nil)
        currentManeuverPage = controller
        maneuverDelegate.routePageViewController(self, willTransitionTo: controller)
    }
    
    func routeManeuverViewController(with step: RouteStep?, leg: RouteLeg?) -> RouteManeuverViewController? {
        guard step != nil else {
            return nil
        }
        
        let storyboard = UIStoryboard(name: "Navigation", bundle: .mapboxNavigation)
        let controller = storyboard.instantiateViewController(withIdentifier: "RouteManeuverViewController") as! RouteManeuverViewController
        controller.step = step
        controller.leg = leg
        return controller
    }
}

extension RoutePageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let controller = viewController as! RouteManeuverViewController
        let stepAfter = maneuverDelegate.stepAfter(controller.step!)
        let leg = maneuverDelegate.currentLeg
        return routeManeuverViewController(with: stepAfter, leg: leg)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let controller = viewController as! RouteManeuverViewController
        let stepBefore = maneuverDelegate.stepBefore(controller.step!)
        let leg = maneuverDelegate.currentLeg
        return routeManeuverViewController(with: stepBefore, leg: leg)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        let controller = pendingViewControllers.first! as! RouteManeuverViewController
        maneuverDelegate.routePageViewController(self, willTransitionTo: controller)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let controller = pageViewController.viewControllers?.last as? RouteManeuverViewController {
                currentManeuverPage = controller
            }
        }
    }
}
