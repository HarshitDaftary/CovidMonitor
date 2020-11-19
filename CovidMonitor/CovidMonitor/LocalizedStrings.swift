//
//  LocalizedStrings.swift
//  CovidMonitor
//
//  Created by Harshit on 19/11/20.
//

import Foundation
import UIKit

protocol Localizable {
    var localized: String { get }
}
extension String: Localizable {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
