//
//  TButton.swift
//  calculator
//
//  Created by artem on 9/1/18.
//  Copyright © 2018 tarasov.Inc. All rights reserved.
//

import UIKit

@IBDesignable
class TButton: UIButton {
  // Begin Styles
  @IBInspectable
  var borderWidth: CGFloat {
    set {
      layer.borderWidth = newValue
    }
    get {
      return layer.borderWidth
    }
  }

  @IBInspectable
  var cornerRadius: CGFloat {
    set {
      layer.cornerRadius = newValue
    }
    get {
      return layer.cornerRadius
    }
  }

  @IBInspectable
  var borderColor: UIColor? {
    set {
      guard let uiColor = newValue else { return }

      layer.borderColor = uiColor.cgColor
    }
    get {
      guard let color = layer.borderColor else { return nil }

      return UIColor(cgColor: color)
    }
  }
  // End Styles

  // Begin Properties
  @IBInspectable
  public var tAction: String!
  // End Properties
}
