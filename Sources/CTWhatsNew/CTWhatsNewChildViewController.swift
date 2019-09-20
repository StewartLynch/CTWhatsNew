//
//  WhatsNewViewController
//  WhatsNew
//
//  Created by Stewart Lynch on 2019-05-04.
//  Copyright © 2019 Stewart Lynch. All rights reserved.
//

import UIKit
import WebKit

@available(iOS 12.0, *)
public protocol CTWhatsNewChildDelegate: AnyObject {
    func resetValue()
}

@available(iOS 12.0, *)
public class CTWhatsNewChildViewController: UIViewController {
    weak var delegate:CTWhatsNewChildDelegate?
    var whatsNew:CTWhatsNew!
    var webView: WKWebView!
    var navBarBarTintColor:UIColor?
    var navBarTintColor:UIColor?
    var navBarTitleColor:UIColor?
    var bgColor:String = "#ffffff"
    var textColor:String = "000000"
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBar()
        loadPage()
    }
    
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
           super.traitCollectionDidChange(previousTraitCollection)
           guard let previousTraitCollection = previousTraitCollection else {return}
               if #available(iOS 13.0, *) {
                   if previousTraitCollection.hasDifferentColorAppearance(comparedTo: traitCollection) {
                       loadPage()
               }
           }
       }

    fileprivate func setupNavBar() {
        let navigationBarAppearance = self.navigationController!.navigationBar
        navigationBarAppearance.prefersLargeTitles = false
        if let navBarColor = navBarBarTintColor {
            navigationBarAppearance.barTintColor = navBarColor
        }
        if let tintColor = navBarTintColor {
            navigationBarAppearance.tintColor = tintColor
        }
        if let titleColor = navBarTitleColor {
            print("Title Color different")
            navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:titleColor]
        }
        let title = Bundle.main.infoDictionary!["CFBundleName"] as! String
        self.navigationItem.title = title
        navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(goBack)), animated: true)
    }
    
    fileprivate func setupView() {
        if #available(iOS 13, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        webView = WKWebView()
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    deinit {
        //        print("WhatsNewViewController deinitialized")
    }
    

    
    fileprivate func loadPage() {
        if #available(iOS 13, *) {
            bgColor = rgbToHex(color: .systemBackground)
            textColor = rgbToHex(color: .label)
        }
        let html = buildHTML(whatsNew: whatsNew)
        webView.loadHTMLString(html, baseURL: Bundle.main.resourceURL)
    }
    
    fileprivate func buildHTML(whatsNew:CTWhatsNew) -> String {
        var html = """
        <!DOCTYPE html>
        <html>
        <head>
        <style>
        body {
        font-family: "Helvetica Neue", sans-serif;
        """
        
        
//      Make size a littler harger if iPhone
        if UIDevice.current.userInterfaceIdiom == .phone {
            html += """
            font-size:36px;
            """
        } else {
            if #available(iOS 13, *) {
                // No Change Required for < iOS13
            } else {
                html += """
                font-size:36px;
                """
            }
        }
        
        html += """
        padding-left: 0.5em;
        padding-right: 0.5em;
        color: \(textColor);
        background-color:\(bgColor);
        }
        
        h1 {
        font-weight: bold;
        text-align: center;
        }
        
        .intro {
        font-style: italic;
        }
        
        .version {
        padding-top: 1.5em;
        font-weight: bold;
        text-transform: uppercase;
        font-size: .75em;
        }
        .versionTitle {
        font-weight:bold;
        }
        
        .description,.versionTitle {
        padding-left: 0.5em;
        }
        </style>
        </head>
        <body>
        <h1>\(whatsNew.title)</h1>
        <div class = 'intro'>\(whatsNew.intro)</div>
        """
        for item in whatsNew.items.reversed() {
            html += """
            <div class = 'version'>Version \(item.version.replacingOccurrences(of: "\n", with: "<br />"))</div>
            <div class = 'versionTitle'>\(item.versionTitle.replacingOccurrences(of: "\n", with: "<br />"))</div>
            <div class = 'description'>\(item.description.replacingOccurrences(of: "\n", with: "<br />"))</div>
            """
        }
        html += """
        </body>
        </html>
        """
        return html
    }
    
    @objc fileprivate func goBack() {
        delegate?.resetValue()
    }
    
    fileprivate func rgbToHex(color: UIColor) -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format: "#%06x", rgb)
    }
    
}
