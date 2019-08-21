//
//  CTWhatsNew.swift
//  WhatsNewTemplate
//
//  Created by Stewart Lynch on 2019-05-05.
//  Copyright © 2019 Stewart Lynch. All rights reserved.
//

import UIKit
/// A Class for creating and presenting a view displaying what is new for this version
/// along with a history of previous updates.
/// - Parameter whatsNew: an item of what is new.
///
/// The Objective:
///
/// By default, the WhatsNew screen will only appear if you have a version number change.
/// If you wish to have the screen appear on demand, you need to pass the isOnDemand: true parameter
///
/// Example
///
/// First decalare an instance of CTWhatsNew and pass in the title and intro values
/// The title is shown as the heading for the view and the intro is a preamble
///
/// ```
///  let whatsNew = CTWhatsNew(title: "What's new Here", intro: "This is what is new")
/// ```
///
///Next, create one or more CTWhatsNew items to build an array of items to be presented.
///
///To create an items, use the newItem function and pass a version number, versionTitle and description
///
///```
///whatsNew.newItem(CTWhatsNewItem(version: "1.0", versionTitle: "Initial Release", description: "This is the first version"))
///whatsNew.newItem(CTWhatsNewItem(version: "2.0", versionTitle: "Update", description: "This is the second version"))
///```
///
/// Now you can present the items with, or without the condition of presenting only on version change.
///
/// ```
          /// SAMPLE CALLS
          ///
          /// Sample calls for the display of the CTWhatsNew view
          /// // default -  displays only when version has changed
          ///  CTWhatsNew.showWhatsNew(on: self, whatsNew: whatsNew)
          ///
          ///  // displays the view on demand
         ///  CTWhatsNew.showWhatsNew(on: self, whatsNew: whatsNew, isOnDemand: true)
         ///
         ///  // displays on demand with optional colors
         ///  CTWhatsNew.showWhatsNew(on: self, whatsNew: whatsNew, navBarBarTintColor: .red, navBarTintColor: .white, isOnDemand: true
  /// ```
          ///
/// ```
///
@available(iOS 12.0, *)

public class CTWhatsNew {

    public var title:String
    public var intro:String
    public var items:[CTWhatsNewItem] = []
    
    public init(title:String, intro:String) {
        self.title = title
        self.intro = intro
    }
    
    /// creates a new CTWhatsNewItem
    ///
    /// - Parameters:
    ///     - ctWhatsNewItem:    a CTWhatsNewItem.
    public func newItem(_ ctWhatsNewItem:CTWhatsNewItem) {
        items.append(ctWhatsNewItem)
    }
   
    
    static public func showWhatsNew(on vC:UIViewController, whatsNew:CTWhatsNew, navBarBarTintColor:UIColor? = nil, navBarTintColor:UIColor? = nil, navBarTitleColor:UIColor? = nil, isOnDemand:Bool = false) {

        if !isOnDemand {
            let appBuild:String = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
            let appVersion:String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
            let verString = "\(appVersion) Build:\(appBuild)"
            let defaults = UserDefaults.standard
            if defaults.string(forKey: "verString") == verString {
                print("Already viewed what's new")
            } else {
                let presentingVc = CTWhatsNewParentViewController()
                presentingVc.containerVC = CTWhatsNewChildViewController()
                presentingVc.whatsNew = whatsNew
                presentingVc.navBarBarTintColor = navBarBarTintColor
                presentingVc.navBarTintColor = navBarTintColor
                presentingVc.navBarTitleColor = navBarTitleColor
                presentingVc.providesPresentationContextTransitionStyle = true
                presentingVc.definesPresentationContext = true
                presentingVc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                presentingVc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                vC.present(presentingVc, animated: true, completion: nil)
            }
        } else {
            let presentingVc = CTWhatsNewParentViewController()
                   presentingVc.containerVC = CTWhatsNewChildViewController()
                   presentingVc.whatsNew = whatsNew
                   presentingVc.navBarBarTintColor = navBarBarTintColor
                   presentingVc.navBarTintColor = navBarTintColor
                   presentingVc.navBarTitleColor = navBarTitleColor
                   presentingVc.providesPresentationContextTransitionStyle = true
                   presentingVc.definesPresentationContext = true
                   presentingVc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                   presentingVc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            vC.present(presentingVc, animated: true, completion: nil)
        }
    }
}

