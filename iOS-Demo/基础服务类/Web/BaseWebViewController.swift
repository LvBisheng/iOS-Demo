//
//  BaseWebViewController.swift
//  iOS-Demo
//
//  Created by lbs on 2020/8/17.
//  Copyright © 2020 LBS. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore

enum XLWekType {
    case loadURL(str: String), loadHtml(fileName: String)
}

class BaseWebViewController: UIViewController {
    var titleName: String?
    var type: XLWekType = .loadURL(str: "https://www.baidu.com")
    
    lazy var webView: WKWebView = {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        let userContentCtrl = WKUserContentController.init()
        userContentCtrl.add(self, name: kLBSJSToNativeMsgName)
        configuration.userContentController = userContentCtrl
        let webView = WKWebView(frame: view.bounds, configuration: configuration)
        view.addSubview(webView)
        webView.uiDelegate = self
        return webView
    }()
    
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = UIColor.orange
        progressView.trackTintColor = UIColor.lightGray
        view.addSubview(progressView)
        return progressView
    }()
    
    deinit {
        webView.removeObserver(self, forKeyPath: "canGoBack", context: nil)
        webView.removeObserver(self, forKeyPath: "estimatedProgress", context: nil)
        webView.removeObserver(self, forKeyPath: "title", context: nil)
        
        print("销毁了")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadData()
        
        testUI()
    }
    
    private func setup() {
        
        view.backgroundColor = .white
        title = titleName
        edgesForExtendedLayout = []
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        webView.addObserver(self, forKeyPath: "canGoBack", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: [.new, .old], context: nil)
        webView.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.new, context: nil)
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        progressView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        updateLeftItems()
    }
    
    private func loadData() {
        switch type {
        case let .loadHtml(fileName):
            let HTML = try! String(contentsOfFile: Bundle.main.path(forResource: fileName, ofType: "html")!, encoding: String.Encoding.utf8)
            webView.loadHTMLString(HTML, baseURL: nil)
        case let .loadURL(str):
            let url = URL(string: str)
            guard let urlStr = url else {
                print("无效路径")
                return
            }
            webView.load(URLRequest(url: urlStr))
        }
    }
    
    // 更新左上角按钮
    private func updateLeftItems() {
        var items: [UIBarButtonItem] = []
        let backItem = UIBarButtonItem(image: UIImage.init(named: "nav_back"), style: .plain, target: self, action: #selector(back))
        items.append(backItem)
        
        let closeItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(close))
        items.append(closeItem)
        
        self.navigationItem.leftBarButtonItems = items
    }
    
    @objc private func back() {
        
        if webView.canGoBack {
            webView.goBack()
        } else {
            close()
        }
    }
    
    @objc private func close() {
        navigationController?.popViewController(animated: true)
    }
}

// 一些测试代码
extension BaseWebViewController {
    private func testUI() {
        let btn = UIButton.init(frame: CGRect.zero)
        btn.setTitle("测试(Native调用JS)", for: UIControl.State.normal)
        btn.frame = CGRect(x: 100, y: view.bounds.size.height - btn.intrinsicContentSize.height - 100, width: btn.intrinsicContentSize.width, height: btn.intrinsicContentSize.height)
        btn.setTitleColor(UIColor.red, for: UIControl.State.normal)
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(testAction), for: UIControl.Event.touchUpInside)
    }
    
    @objc private func testAction() {
        webView.evaluateJavaScript("nativeToJsMsgMethod('ABCD')") { (result, error) in
            if let e = error {
                print("Native 调用 JS失败 \(e)")
            } else {
                print("Native 调用 JS成功")
            }
        }
    }
}

extension BaseWebViewController {
    // MARK:- 监听 进度条、标题
    open override func observeValue(forKeyPath keyPath: String?,
                                    of object: Any?,
                                    change: [NSKeyValueChangeKey: Any]?,
                                    context: UnsafeMutableRawPointer?) {
        
        
        guard let theKeyPath = keyPath, object as? WKWebView == webView else {
            return
        }
        if theKeyPath == "canGoBack" {
            if let newValue = change?[NSKeyValueChangeKey.newKey] {
                let newV = newValue as! Bool
                if newV == true{
                    navigationController?.interactivePopGestureRecognizer?.isEnabled = false;
                }else{
                    navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
                }
            }
            updateLeftItems()
        } else if theKeyPath == "estimatedProgress"{
            if webView.isEqual(object) {
                progressView.isHidden = webView.estimatedProgress == 1.0
                progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            }
        } else if theKeyPath == "title" {
            if titleName == nil {
                self.title = webView.title
            }
        }
    }
}

extension BaseWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        LBSJSHandleService.shared.handleJSMessage(message, currentController: self)
    }
}

/// 自定义弹框
extension BaseWebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertCtrl = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "确定", style: .default) { (alert) in
            completionHandler()
        }
        alertCtrl.addAction(okAction)
        present(alertCtrl, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertCtrl = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .default) { (_) in
            completionHandler(false)
        }
        let okAction = UIAlertAction.init(title: "确定", style: .default) { (alert) in
            completionHandler(true)
        }
        alertCtrl.addAction(cancelAction)
        alertCtrl.addAction(okAction)
        present(alertCtrl, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alertCtrl = UIAlertController(title: prompt, message: "", preferredStyle: .alert)
        alertCtrl.addTextField { (tf) in
            tf.text = defaultText
        }
        let okAction = UIAlertAction.init(title: "确定", style: .default) { (alert) in
            completionHandler(alertCtrl.textFields?.first?.text ?? "")
        }
        alertCtrl.addAction(okAction)
        present(alertCtrl, animated: true, completion: nil)
    }
}
