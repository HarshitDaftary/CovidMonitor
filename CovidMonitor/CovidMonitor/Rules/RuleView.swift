//
//  RuleView.swift
//  CovidMonitor
//
//  Created by Harshit on 18/11/20.
//

import UIKit
import Foundation

@IBDesignable
class RuleView: UIView {
    static let RULES_VIEW_NIB = "RuleView"
    
    @IBOutlet var vwContent: UIView!
    @IBOutlet var imgRule: UIImageView!
    @IBOutlet var txtvDescription: UITextView!
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initWithNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initWithNib()
    }
    
    convenience init(image: String? = "", description: String? = "") {
        self.init()
        self.imgRule.image = UIImage(named: image!)
        self.txtvDescription.text = description!
    }
    
    fileprivate func initWithNib() {
        Bundle.main.loadNibNamed(RuleView.RULES_VIEW_NIB, owner: self, options: nil)
        vwContent.frame = bounds
        vwContent.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(vwContent)
    }
}
