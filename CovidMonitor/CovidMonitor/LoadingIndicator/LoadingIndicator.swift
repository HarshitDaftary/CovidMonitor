//
//  LoadingExtension.swift
//  CovidMonitor
//
//  Created by Harshit on 19/11/20.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showLoading() {
        
        if let _ = view.viewWithTag(100) as? UIImageView {
            return
        }
        
        let loadingView = UIImageView(frame: self.view.bounds)
        loadingView.image = #imageLiteral(resourceName: "green_signal")
        loadingView.frame = CGRect(origin: CGPoint(x: self.view.bounds.width, y: self.view.center.y/2), size: loadingView.image!.size)
        
        loadingView.animationImages = [#imageLiteral(resourceName: "green_signal"),#imageLiteral(resourceName: "yellow_signal"),#imageLiteral(resourceName: "red_signal")]
        loadingView.animationDuration = 0.8
        loadingView.tag = 100
        loadingView.startAnimating()
        view.addSubview(loadingView)
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.1, options: []) {
            loadingView.frame = CGRect(origin: CGPoint(x: self.view.bounds.width - (loadingView.image?.size.width)!, y: self.view.center.y/2), size: loadingView.image!.size)
        } completion: {_ in
        }
    }
    
    func hideLoading(){
        guard let loadingView = view.viewWithTag(100) as? UIImageView else {
          return
        }
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.1, options: []) {
            loadingView.frame = CGRect(origin: CGPoint(x: self.view.bounds.width, y: self.view.center.y/2), size: loadingView.image!.size)
        } completion: {_ in
            loadingView.removeFromSuperview()
        }
    }
}
