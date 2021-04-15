//
//  TEFontManager.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/14/21.
//

import UIKit

typealias AppFonts = TEFontManager

enum FontFaces: String {
    case extraLight = "ExtraLight"
    case light = "Light"
    case regular = "Regular"
    case medium = "Medium"
    case extraBold = "ExtraBold"
    case bold = "Bold"
    case black = "Black"
    case heavy = "Heavy"
}

class TEFontManager {
    
    struct Satoshi {
        static let name = "Satoshi"
        static let faces: [FontFaces] = [
            .light,
            .regular,
            .medium,
            .bold,
            .black
        ]
        static func font(face: FontFaces, size: CGFloat) -> UIFont? {
            let formattedName = "\(name)-\(face.rawValue)"
            return UIFont(name: formattedName, size: size)
        }
    }
    
}
