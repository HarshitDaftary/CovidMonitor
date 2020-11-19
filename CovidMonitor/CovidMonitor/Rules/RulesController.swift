//
//  RulesController.swift
//  CovidMonitor
//
//  Created by Harshit on 17/11/20.
//

import UIKit

class RulesController: UIViewController {
    
    var caseCount = 0
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rulesRepository = RuleRepository()
        rulesRepository.loadFile()
        let zoneName = rulesRepository.getZoneName(caseCount: caseCount)
        lblTitle.text = titleRules.localized +  zoneName!.localized
        topView.backgroundColor = UIColor(named: rulesRepository.getRuleColor(caseCount: caseCount))!.withAlphaComponent(0.4)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedRulesPageController" {
            let destination = segue.destination as! RulesPageController
            destination.caseCount = caseCount
        }
    }
}
