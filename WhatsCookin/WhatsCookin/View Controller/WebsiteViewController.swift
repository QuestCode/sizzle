//
//  WebsiteViewController.swift
//  Sizzle
//
//  Created by Devontae Reid on 8/2/16.
//  Copyright © 2016 Devontae Reid. All rights reserved.
//

import UIKit

class WebsiteViewController: UIViewController {

    let webView = UIWebView()
    var website = NSURL()
    
    let toolBar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // So that navigation bar does not hide the tableview
        self.edgesForExtendedLayout = .all
        
        view.backgroundColor = UIColor.peachColor()
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        view.addConstraints([
            NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: webView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: webView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
            ])
        
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.items = [UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(UIWebView.goBack)),UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(UIWebView.goForward)),UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: Selector(("refresh")))]
        webView.addSubview(toolBar)
        webView.addConstraints([
            NSLayoutConstraint(item: toolBar, attribute: .top, relatedBy: .equal, toItem: webView, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: toolBar, attribute: .left, relatedBy: .equal, toItem: webView, attribute: .left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: toolBar, attribute: .right, relatedBy: .equal, toItem: webView, attribute: .right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: toolBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 50)
            ])
        // Request
        let request = NSURLRequest(url: website as URL)
        
        webView.loadRequest(request as URLRequest)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goForward() {
        webView.goForward()
    }
    
    func goBack() {
        webView.goBack()
    }
    
    func refresh() {
        webView.reload()
    }

}
