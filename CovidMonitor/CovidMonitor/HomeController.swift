//
//  HomeController.swift
//  CovidMonitor
//
//  Created by Harshit on 12/11/20.
//

import UIKit

class MapController: UIViewController {

    private var originalPullUpControllerViewSize: CGSize = .zero
    override func viewDidLoad() {
        super.viewDidLoad()
        addPullUpController(animated: true)
    }
    
    private func makeSearchViewControllerIfNeeded() -> SearchViewController {
        let currentPullUpController = children
            .filter({ $0 is SearchViewController })
            .first as? SearchViewController
        let pullUpController: SearchViewController = currentPullUpController ?? UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        pullUpController.initialState = .contracted
//        if initialStateSegmentedControl.selectedSegmentIndex == 0 {
//            pullUpController.initialState = .contracted
//        } else {
//            pullUpController.initialState = .expanded
//        }
        if originalPullUpControllerViewSize == .zero {
            originalPullUpControllerViewSize = pullUpController.view.bounds.size
        }

        return pullUpController
    }

    private func addPullUpController(animated: Bool) {
        let pullUpController = makeSearchViewControllerIfNeeded()
        _ = pullUpController.view // call pullUpController.viewDidLoad()
        addPullUpController(pullUpController,
                            initialStickyPointOffset: pullUpController.initialPointOffset,
                            animated: animated)
    }
}
