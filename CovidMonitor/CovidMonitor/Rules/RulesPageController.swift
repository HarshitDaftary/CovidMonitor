//
//  RulesPageController.swift
//  CovidMonitor
//
//  Created by Harshit on 18/11/20.
//

import UIKit

class RulesPageController: UIPageViewController {

    fileprivate var items: [UIViewController] = []
    var caseCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        decoratePageControl()
        
        populateItems()
        if let firstViewController = items.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    fileprivate func decoratePageControl() {
        let pc = UIPageControl.appearance(whenContainedInInstancesOf: [RulesPageController.self])
        pc.currentPageIndicatorTintColor = .orange
        pc.pageIndicatorTintColor = .gray
    }
    
    fileprivate func populateItems() {
        let ruleRepository = RuleRepository()
        ruleRepository.loadFile()
        let rules = ruleRepository.getRules(caseCount: caseCount)
        for rule in rules {
            let controller = createRulePageControler(with: rule)
            items.append(controller)
        }
    }
    
    fileprivate func createRulePageControler(with rule: ZoneRule?) -> UIViewController {
        let c = UIViewController()
        c.view = RuleView(image: rule?.image, description: rule?.description?.localized)
        return c
    }
}

extension RulesPageController: UIPageViewControllerDataSource {
    func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = items.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return items.last
        }
        
        guard items.count > previousIndex else {
            return nil
        }
        
        return items[previousIndex]
    }
    
    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = items.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        guard items.count != nextIndex else {
            return items.first
        }
        
        guard items.count > nextIndex else {
            return nil
        }
        
        return items[nextIndex]
    }
    
    func presentationCount(for _: UIPageViewController) -> Int {
        return items.count
    }
    
    func presentationIndex(for _: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
              let firstViewControllerIndex = items.firstIndex(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
}

