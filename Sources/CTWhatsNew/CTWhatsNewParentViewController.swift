//
//  FullContextViewController.swift
//  WhatsNew
//
//  Created by Stewart Lynch on 2019-05-04.
//  Copyright © 2019 Stewart Lynch. All rights reserved.
//

import UIKit

@available(iOS 12.0, *)
public class CTWhatsNewParentViewController: UIViewController {
    var containerVC: UIViewController!
    var whatsNew:CTWhatsNew!
    var navBarBarTintColor:UIColor?
    var navBarTintColor:UIColor?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0, green: 0, blue:0, alpha: 0.4)
        showContainer()
    }
    
    fileprivate func showContainer() {
        var vw:UIView!
        guard let childVC = containerVC as? CTWhatsNewChildViewController else { return }
        let navVC = UINavigationController(rootViewController: childVC)
        childVC.whatsNew = whatsNew
        addChild(navVC)
        navVC.view.frame = .zero
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        childVC.delegate = self
        childVC.navBarBarTintColor = navBarBarTintColor
        childVC.navBarTintColor = navBarTintColor
        vw = navVC.view
        vw?.layer.cornerRadius = 10
        vw?.layer.borderWidth = 1
        vw?.clipsToBounds = true
        vw?.layer.borderColor = UIColor.lightGray.cgColor
        vw?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        navVC.view.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = vw?.widthAnchor.constraint(equalToConstant: 500)
        widthConstraint?.priority = UILayoutPriority(rawValue: 750)
        widthConstraint?.isActive = true
        vw?.widthAnchor.constraint(greaterThanOrEqualToConstant: 300).isActive = true
        vw?.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        vw?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        vw?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        
    }
    
    
    deinit {
        if let view = view {
            willMove(toParent: nil)
            view.removeFromSuperview()
            removeFromParent()
        }
    }
}

@available(iOS 12.0, *)
extension CTWhatsNewParentViewController: CTWhatsNewChildDelegate {
    public func resetValue() {
        let defaults = UserDefaults.standard
        
        let appBuild:String = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
        let appVersion:String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let verString = "\(appVersion) Build:\(appBuild)"
        defaults.set(verString, forKey: "verString")
        dismiss(animated: true)
    }
    
    
}
