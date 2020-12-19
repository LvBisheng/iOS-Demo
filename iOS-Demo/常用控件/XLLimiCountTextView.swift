//
//  XLLimiCountTextView.swift
//  iOS-Demo
//
//  Created by lbs on 2020/12/19.
//  Copyright © 2020 LBS. All rights reserved.
//

import UIKit
import RSKPlaceholderTextView

/// 带有字数限制的UITextView
class XLLimiCountTextView: UIView {
    
    private(set) var textView: RSKPlaceholderTextView = RSKPlaceholderTextView()
    private(set) var wordCountLabel: UILabel = UILabel()
    
    typealias XLLimiCountTextViewClosure = (_ tv: UITextView) -> Void
    var tvBlock : XLLimiCountTextViewClosure?
    
    var maxCount: Int = 10 {
        didSet {
            updateLimitDescribe()
        }
    }
    
    class func defaultTextView(_ needWordTip: Bool = true) -> XLLimiCountTextView{
        let instance = XLLimiCountTextView.init()
        instance.setup(needWordTip: needWordTip)
        return instance
    }
    
    func setContent(_ text: String) {
        var newString = text
        if text.count > maxCount {
            newString = String(text.prefix(maxCount))
        }
        textView.text = newString
        updateLimitDescribe()
    }
    
    private func setup(needWordTip: Bool) {
        textView.delegate = self
        self.addSubview(textView)
        
        wordCountLabel.textAlignment = .right
        wordCountLabel.font = UIFont.systemFont(ofSize: 11)
        wordCountLabel.textColor = .lightGray
        wordCountLabel.isHidden = !needWordTip
        addSubview(wordCountLabel)
        updateLimitDescribe()
    }
    
  
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textView.frame = self.bounds
        
        let labelHeight:CGFloat = 30
        let labelWidth: CGFloat = 50
        wordCountLabel.frame = CGRect(x: self.bounds.size.width - labelWidth, y: self.bounds.size.height - labelHeight, width: labelWidth, height: labelHeight)
    }
    
    // 更新字数限制描述
    private func updateLimitDescribe() {
        let text = "\(textView.text.count)/" + "\(self.maxCount)"
        wordCountLabel.text = text
    }
}

extension XLLimiCountTextView: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > maxCount {
            let newString = String(textView.text!.prefix(maxCount))
            textView.text = newString
            textView.undoManager?.removeAllActions()
            textView.becomeFirstResponder()
        }
        updateLimitDescribe()
        tvBlock?(textView)
    }
}

