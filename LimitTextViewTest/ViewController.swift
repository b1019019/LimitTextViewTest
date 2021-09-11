//
//  ViewController.swift
//  LimitTextViewTest
//
//  Created by 山田純平 on 2021/09/10.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView1: UITextView!
    
    var textEndChar: String.SubSequence = ""
    var textEndX: CGPoint = CGPoint(x: 0, y: 0)
    let textViewMaxHight: CGFloat = 183.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textView1.delegate = self
        textView1.text = "mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmwtwmtmwtmwmtmwmrmgwegbwdfdfmggmfmfmfrsfdmdsrfsmfmsmfrmsfmgrmsfmgmsfmgmsfmsmmgmsgmmwmrmgrmsmgmsmgmsmmgsmmgsmgmsmmgmsmgmsmfgmsmmg"
        print(textView1.contentHuggingPriority(for: .vertical))
        print(textView1.contentCompressionResistancePriority(for: .vertical))
        textView1.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
        textViewDidChange(textView1)
        
    }
    
    
    override func viewWillLayoutSubviews() {
        //intrinsticContentSizeを元にオートレイアウトを計算する
        //ハギングとコンプレッションの優先度以上にする。
        print("intrinstic",textView1.intrinsicContentSize)
        
        //out of range
        if textView1.text.count == 0 {
            textEndChar = ""
            textEndX = CGPoint(x: 0, y: 0)
            return
        }
        
        let newTextEndChar = textView1.text.suffix(1)
        let newTextEndX = textView1.layoutManager.location(forGlyphAt: textView1.text.count - 1)
        
        //全角スペースも
        let isTextEndDoubleSpace = (newTextEndChar == " " || newTextEndChar == "　") && (textEndChar == " " || textEndChar == "　")
        if isTextEndDoubleSpace && newTextEndX == textEndX {
            textView1.text = String(textView1.text.dropLast())
        }
        textEndChar = newTextEndChar
        textEndX = newTextEndX
        
    }
    


}

extension ViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        print(textView1.text.count)
        let size = CGSize(width: textView.frame.width, height: .infinity)
        //sizeThatFits:引数のCGSizeより小さい、textViewのちょうど良いサイズを求める。
        //LabelやTextViewなどは中のテキストが全部表示されるようなサイズが求められる
        let estimatedSize = textView.sizeThatFits(size)
        if textViewMaxHight < estimatedSize.height {
            textView.text = String(textView.text.dropLast())
        }
        //制約が適用される前に制約を変更している
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = min(textViewMaxHight,estimatedSize.height)
                
                print("coSet")
            }
        }
        print("height",textViewMaxHight,estimatedSize.height)
    }
    
}

extension UITextView {
    func fafa() {
        
    }
}

