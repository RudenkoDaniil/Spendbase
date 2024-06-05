import Foundation
import UIKit

extension UIColor {
    static let secondText = makeColor(0x7E8493)
    static let mainBackground = makeColor(0xF6F7F9)
    static let cardBackground = makeColor(0x2B2C39)
    
    static let backgroundColor = makeColor(0xffffff)
    static func makeColor(_ rgbValue: Int) -> UIColor {
        return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((rgbValue & 0x00FF00) >> 8))/255.0, blue: ((CGFloat)((rgbValue & 0x0000FF)))/255.0, alpha: 1.0)
    }
}
