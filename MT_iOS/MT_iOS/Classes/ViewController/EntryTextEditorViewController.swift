//
//  EntryTextEditorViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/05.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class EntryTextEditorViewController: BaseViewController, UITextViewDelegate {

    var textView: UITextView!

    var object: EntryTextItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.textView = UITextView(frame: self.view.bounds)
        self.textView.autocapitalizationType = UITextAutocapitalizationType.None
        self.textView.autocorrectionType = UITextAutocorrectionType.No
        self.textView.font = UIFont.systemFontOfSize(13.0)
        self.textView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        self.textView.autoresizesSubviews = true
        self.textView.delegate = self
        
        self.view.addSubview(self.textView)
        
        self.title = object.label
        self.textView.text = object.text
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "saveButtonPushed:")
        
        self.textView.becomeFirstResponder()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func keyboardWillShow(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration: NSTimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        
        var insets = self.textView.contentInset
        insets.bottom += keyboardFrame.size.height
        UIView.animateWithDuration(duration, animations:
            {_ in
                self.textView.contentInset = insets;
            }
        )
    }
    
    func keyboardWillHide(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration: NSTimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        
        var insets = self.textView.contentInset
        insets.bottom = 0
        UIView.animateWithDuration(duration, animations:
            {_ in
                self.textView.contentInset = insets;
            }
        )
    }
    
    @IBAction func saveButtonPushed(sender: UIBarButtonItem) {
        object.text = textView.text
        self.navigationController?.popViewControllerAnimated(true)
    }
}
