//
//  UIColor+Extensioin.swift
//  VimeoSProject001
//
//  Created by Willy Hsu on 2025/11/15.
//

import UIKit

extension UIColor {

    convenience init?(hexString: String, alpha: CGFloat? = nil) {
        self.init(hex: hexString, alpha: alpha)
    }

    convenience init?(hex: String, alpha: CGFloat? = nil) {
        guard let components = Self.parseHex(hex, fallbackAlpha: alpha) else {
            return nil
        }

        self.init(red: components.r,
                  green: components.g,
                  blue: components.b,
                  alpha: components.a)
    }

    static func hex(_ hex: String,
                    alpha: CGFloat? = nil,
                    default defaultColor: UIColor = .clear) -> UIColor {
        guard let components = parseHex(hex, fallbackAlpha: alpha) else {
            return defaultColor
        }

        return UIColor(red: components.r,
                       green: components.g,
                       blue: components.b,
                       alpha: components.a)
    }

    private static func parseHex(_ hex: String,
                                 fallbackAlpha: CGFloat?) -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)? {

        let trimmed = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "^0x|^#", with: "", options: [.regularExpression, .caseInsensitive])
            .uppercased()

        guard !trimmed.isEmpty else { return nil }

        let allowedCharacters = CharacterSet(charactersIn: "0123456789ABCDEF")
        guard trimmed.unicodeScalars.allSatisfy({ allowedCharacters.contains($0) }) else {
            return nil
        }

        var cleaned = trimmed
        switch cleaned.count {
        case 3, 4:
            cleaned = cleaned.map { "\($0)\($0)" }.joined()
        case 6, 8:
            break
        default:
            return nil
        }

        var value: UInt64 = 0
        guard Scanner(string: cleaned).scanHexInt64(&value) else {
            return nil
        }

        let r: CGFloat
        let g: CGFloat
        let b: CGFloat
        let a: CGFloat

        if cleaned.count == 8 {
            r = CGFloat((value & 0xFF00_0000) >> 24) / 255.0
            g = CGFloat((value & 0x00FF_0000) >> 16) / 255.0
            b = CGFloat((value & 0x0000_FF00) >> 8) / 255.0
            a = CGFloat(value & 0x0000_00FF) / 255.0
        } else {
            r = CGFloat((value & 0xFF00_00) >> 16) / 255.0
            g = CGFloat((value & 0x00FF_00) >> 8) / 255.0
            b = CGFloat(value & 0x0000_FF) / 255.0

            let normalizedAlpha = fallbackAlpha.map { max(0.0, min(1.0, $0)) } ?? 1.0
            a = normalizedAlpha
        }

        return (r, g, b, a)
    }

    // MARK: - Vimeo Brand Colors
    static let vimeoBlack = hex("#141A20")
    static let vimeoBlue = hex("#17D5FF")
    static let vimeoWhite = hex("#FAFCFD")
}
