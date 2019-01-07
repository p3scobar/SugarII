//
//  Tools.swift
//  devberg
//
//  Created by Hackr on 10/3/17.
//  Copyright © 2017 Hackr. All rights reserved.
//

import UIKit
import AVFoundation

internal func generateChatId(ids:[String]) -> String {
    return ids.sorted(by:>).joined().md5()
}

extension UIColor {
    convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}

extension String {
    func parseUrls() -> URL? {
        var link: URL?
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            detector.enumerateMatches(in: self, options: [], range: NSMakeRange(0, self.count), using: { (result, _, _) in
                if let match = result, let url = match.url {
                    link = url
                    var urlString = url.absoluteString
                    if urlString.hasPrefix("http://") {
                        let index = urlString.index(urlString.startIndex, offsetBy: 4)
                        urlString.insert("s", at: index)
                    }
                    if urlString.hasPrefix("www.") {
                        urlString = "https://" + urlString
                    }
                }
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return link
    }
}

extension String {
    func heightWithConstrainedWidth(font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: UIScreen.main.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return boundingBox.height
    }
}

extension Double {
    
    struct Number {
        static let formatterUSD: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale?
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 2
            return formatter
        }()
    }
    
    var currencyUSD: String {
        let amount = self as NSNumber
        return Number.formatterUSD.string(from: amount) ?? "$0.00"
    }
    
    func asCurrency() -> String {
        return String(format: "$%.02f", self)
    }
}



extension UIView {
    func pushTransition(_ duration:CFTimeInterval) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionPush
        animation.subtype = kCATransitionFromTop
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionPush)
    }
}


internal func estimateFrameForText(text: String, fontSize: CGFloat) -> CGRect {
    let width = UIScreen.main.bounds.width-40
    let size = CGSize(width: width, height: 320)
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize)], context: nil)
}

internal func estimateChatBubbleSize(text: String, fontSize: CGFloat) -> CGSize {
    let size = CGSize(width: 240, height: 600)
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: Theme.medium(fontSize)], context: nil).size
}

extension String {
    func isValidURL() -> Bool {
        if let url = URL(string: self) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.width)
    }
}


extension NSMutableAttributedString {
    func setColor(color: UIColor, forText stringValue: String) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
    }
}


extension UIImage {
    class func imageWithView(_ view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0)
        defer { UIGraphicsEndImageContext() }
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}

extension String {
    
    func height(forWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    func mentions(string: String) -> [String:Bool] {
        let names = matches(for: "(?:^|\\s|$|[.])@[\\p{L}0-9_]*", in: string)
        var usernames = [String:Bool]()
        for n in names {
            var name = n
            name = name.trimmingCharacters(in: .whitespaces)
            name = name.trimmingCharacters(in: .punctuationCharacters)
            name = name.lowercased()
            usernames[name] = true
        }
        return usernames
    }
    
    func hashtags(string: String) -> [String: Int] {
        let timestamp = Int(Date().timeIntervalSince1970)
        let tags = matches(for: "(?:^|\\s|$)#[\\p{L}0-9_]*", in: string)
        var hashtags = [String:Int]()
        for t in tags {
            var tag = t
            tag = tag.trimmingCharacters(in: .whitespaces)
            tag = tag.trimmingCharacters(in: .punctuationCharacters)
            tag = tag.lowercased()
            hashtags[tag] = timestamp
        }
        return hashtags
    }
    
    
    fileprivate func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}

extension Decimal {
    
    func rounded(_ decimals: Int) -> String {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.minimumFractionDigits = decimals
        formatter.maximumFractionDigits = decimals
        return formatter.string(from: self as NSDecimalNumber) ?? ""
    }
    
    func roundedDecimal() -> Decimal {
        let number = NSDecimalNumber(decimal: self)
        let rounding = NSDecimalNumberHandler(roundingMode: .bankers, scale: 7, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        return number.rounding(accordingToBehavior: rounding).decimalValue
    }
    
}


extension String {
    
    func currency(_ decimals: Int) -> String {
        return Decimal(string: self)?.rounded(decimals) ?? "0.000"
    }
    
}



internal func setupDefaultaAvatar() {
    let pixelView = PixelView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
    let image = UIImage.imageWithView(pixelView)
    UserManager.updateProfilePic(image: image)
}
