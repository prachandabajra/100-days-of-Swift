//
//  ViewController.swift
//  Project4
//
//  Created by Prachanda Muni Bajracharya on 2/4/21.
//  Copyright © 2021 Prachanda Muni Bajracharya. All rights reserved.
//

import UIKit
import WebKit

// ViewController inherits from UIViewController class and conforms to WKNavigationDelegate protocol.
class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = [String]()
    var selectedWebsite = String()

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        let goBack = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        let goForward = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))
        
        toolbarItems = [progressButton, spacer, goBack, spacer, refresh, spacer, goForward]
        navigationController?.isToolbarHidden = false
        
        // forKeyPath isn't named forProperty because it's not just about entering a property name. You can actually specify a path: one property inside another, inside another, and so on. More advanced key paths can even add functionality, such as averaging all elements in an array!
        // Swift has a special keyword, #keyPath, which works like the #selector keyword you saw previously: it allows the compiler to check that your code is correct – that the WKWebView class actually has an estimatedProgress property.
        // context is easier: if you provide a unique value, that same context value gets sent back to you when you get your notification that the value has changed. This allows you to check the context to make sure it was your observer that was called. There are some corner cases where specifying (and checking) a context is required to avoid bugs, but you won't reach them during any of this series.
        // Warning: in more complex applications, all calls to addObserver() should be matched with a call to removeObserver() when you're finished observing – for example, when you're done with the view controller.
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        let url = URL(string: "https://" +  selectedWebsite)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        guard let actionTitle = action.title else {
            return
        }
        guard let url = URL(string: "https://" + actionTitle) else {
            return
        }
//        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            //  estimatedProgress is a Double
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    // This delegate callback allows us to decide whether we want to allow navigation to happen or not every time something happens. We can check which part of the page started the navigation, we can see whether it was triggered by a link being clicked or a form being submitted, or, in our case, we can check the URL to see whether we like it.
    // This decisionHandler is also a closure, except it's the other way around – rather than giving someone else a chunk of code to execute, you're being given it and are required to execute it.
    // Because you might call the decisionHandler closure straight away, or you might call it later on (perhaps after asking the user what they want to do), Swift considers it to be an escaping closure. That is, the closure has the potential to escape the current method, and be used at a later date.
    // Because of this, Swift wants us to add the special keyword @escaping when specifying this method
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
//        print (url?.absoluteString)
//        guard let stringURL = url?.absoluteString else { return }
        
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        
        decisionHandler(.cancel)
               
        guard let blockedUrl = url else {
            return
        }

        if UIApplication.shared.canOpenURL(blockedUrl as URL) {
            showWarning(alertTitle: "Blocked", alertMessage: "You are not allowed to visit \(blockedUrl)", alertAction: "Ok")
        }
    }
    
    func showWarning(alertTitle: String, alertMessage: String, alertAction: String) {
        let ac = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: alertAction, style: .default))
        present(ac, animated: true)
    }
}

