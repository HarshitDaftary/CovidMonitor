//
//  SearchController.swift
//  CovidMonitor
//
//  Created by Harshit on 12/11/2020.
//
import UIKit
import MapKit
import PullUpController

extension UIViewController {

    var hasSafeArea: Bool {
        guard
            #available(iOS 11.0, tvOS 11.0, *)
            else {
                return false
            }
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
    }

}

class SearchController: PullUpController {
    
    enum InitialState {
        case contracted
        case expanded
    }
    
    var initialState: InitialState = .contracted
    let ruleRepository = RuleRepository()
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var visualEffectView: UIVisualEffectView!
    @IBOutlet private weak var searchBoxContainerView: UIView!
    @IBOutlet private weak var searchSeparatorView: UIView! {
        didSet {
            searchSeparatorView.layer.cornerRadius = searchSeparatorView.frame.height/2
        }
    }
    @IBOutlet private weak var firstPreviewView: UIView!
    @IBOutlet private weak var secondPreviewView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    
    var initialPointOffset: CGFloat {
        switch initialState {
        case .contracted:
            return (searchBoxContainerView?.frame.height ?? 0) + safeAreaAdditionalOffset
        case .expanded:
            return pullUpControllerPreferredSize.height
        }
    }

    private var locations:[MapRegion]!
    
    public var portraitSize: CGSize = .zero
    public var landscapeFrame: CGRect = .zero

    private var safeAreaAdditionalOffset: CGFloat {
        hasSafeArea ? 20 : 0
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        portraitSize = CGSize(width: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height),
                              height: secondPreviewView.frame.maxY)
        landscapeFrame = CGRect(x: 5, y: 50, width: 280, height: 300)
        
        tableView.attach(to: self)
        ruleRepository.loadFile()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.layer.cornerRadius = 12
    }
    
    override func pullUpControllerWillMove(to stickyPoint: CGFloat) {
//        print("will move to \(stickyPoint)")
    }
    
    override func pullUpControllerDidMove(to stickyPoint: CGFloat) {
//        print("did move to \(stickyPoint)")
    }
    
    override func pullUpControllerDidDrag(to point: CGFloat) {
//        print("did drag to \(point)")
    }
        
    // MARK: - DataUpdated
    
    func updateLocations(updatedLocations:[MapRegion]) {
        locations = updatedLocations
        tableView.reloadData()
    }
    
    // MARK: - PullUpController
    
    override var pullUpControllerPreferredSize: CGSize {
        return portraitSize
    }
    
    override var pullUpControllerPreferredLandscapeFrame: CGRect {
        return landscapeFrame
    }
    
    override var pullUpControllerMiddleStickyPoints: [CGFloat] {
        switch initialState {
        case .contracted:
            return [firstPreviewView.frame.maxY]
        case .expanded:
            return [searchBoxContainerView.frame.maxY + safeAreaAdditionalOffset, firstPreviewView.frame.maxY]
        }
    }
    
    override var pullUpControllerBounceOffset: CGFloat {
        return 20
    }
    
    override func pullUpControllerAnimate(action: PullUpController.Action,
                                          withDuration duration: TimeInterval,
                                          animations: @escaping () -> Void,
                                          completion: ((Bool) -> Void)?) {
        switch action {
        case .move:
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: animations,
                           completion: completion)
        default:
            UIView.animate(withDuration: 0.3,
                           animations: animations,
                           completion: completion)
        }
    }
    
}

extension SearchController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell",
                                                     for: indexPath) as? SearchResultCell
            else { return UITableViewCell() }
        
        let location = locations[indexPath.row]
        cell.configure(location: location.location_name, count: "\(Int(location.cases))")
        let colorName = ruleRepository.getRuleColor(caseCount: Int(location.cases))
        cell.lblCaseCount.backgroundColor = UIColor(named: colorName!)?.withAlphaComponent(0.4)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        view.endEditing(true)
        pullUpControllerMoveToVisiblePoint(pullUpControllerMiddleStickyPoints[0], animated: true, completion: nil)
        
        (parent as? MapController)?.focusOnLocation(location: locations[indexPath.row])
    }
}
