//
//  K.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/11/21.
//

import UIKit

struct K {
  
  struct Colors {
    static let Black = UIColor(named: "Black")!
    static let Blue = UIColor(named: "AccentColor")!
    static let Gray = UIColor(named: "Gray")!
    static let Green = UIColor(named: "Green")!
    static let Red = UIColor(named: "Red")!
    static let Yellow = UIColor(named: "Yellow")!
    static let White = UIColor(named: "White")!
    static let Background = UIColor(named: "Background")!
    static let Foreground = UIColor(named: "Foreground")!
    static let DimmedForeground = UIColor(named: "Foreground")!.withAlphaComponent(0.65)
    static let TransparentButtons = UIColor(named: "TransparentButtons")!
    static let Borders = UIColor(named: "Borders")!
  }
  
  struct Icons {
    static let Accept = "checkmark"
    static let Deny = "xmark"
    static let Enlarge = "arrow.up.left.and.arrow.down.right"
    static let Back = "arrow.backward"
    static let Close = "xmark"
    static let Share = "square.and.arrow.up"
    static let Save = "square.and.arrow.down"
    static let Exclamation = "questionmark.circle"
    static let CameraError = "eye.slash"
    static let Classifier = "eye.fill"
    static let Gallery = "photo.on.rectangle.angled"
    static let Shoot = "camera.fill"
    static let Flip = "arrow.triangle.2.circlepath"
    static let FlashOn = "bolt.fill"
    static let FlashOff = "bolt.slash.fill"
    static let TorchOn = "flame.fill"
    static let TorchOff = "flame"
    static let CaptureSmart = "viewfinder"
    static let CaptureManual = "crop"
    static let ArrowRight = "chevron.forward"
    static let Info = "info.circle.fill"
    static let Eyes = "eyes"
    static let ApprovalSeal = "checkmark.seal.fill"
    static let Analysis = "sparkles.square.fill.on.square"
    static let ArrowUpSquare = "arrow.up.square.fill"
    static let ArrowMidSquare = "arrow.left.and.right.square.fill"
    static let ArrowDownSquare = "arrow.down.square.fill"
    static let ThumbUp = "hand.thumbsup.fill"
    static let ThumbDown = "hand.thumbsdown.fill"
  }
  
  struct Sizes {
    static let NavigationHeader: CGFloat = 17
  }
  
}

