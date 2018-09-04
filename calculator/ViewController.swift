//
//  ViewController.swift
//  calculator
//
//  Created by artem on 9/1/18.
//  Copyright © 2018 tarasov.Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private var value = (
    previous: "0",
    current: "0"
  )
  private var selectedAction = ""
  private var override = false
  private var lastAction = ""
  
  private let actions = (
    clear: "clear",
    abc: "abc",
    percent: "percent",
    division: "division",
    multiplication: "multiplication",
    minus: "minus",
    plus: "plus",
    equal: "equal",
    dot: "dot"
  )
  
  @IBOutlet var label: UILabel!
  
  @IBAction func handleClickNumber(_ sender: TButton) {
    if isEmpty(label.text!) || override {
      value.current = String(sender.tag)
    } else if getLength(value.current) < 9 {
      value.current += String(sender.tag)
    }
    
    override = false
    handleViewLabel()
  }
  
  @IBAction func handleClickAction(_ sender: TButton) {
    handleAction(sender.tAction)
  }
  
  private func handleAction(_ action: String) {
    switch action {
    case actions.clear:
      override = true
      handleClear()
      break;
    case actions.abc:
      handleABC()
      break
    case actions.percent:
      override = true
      handlePercent()
      break
    case actions.division,
         actions.multiplication,
         actions.minus,
         actions.plus:
      override = true
      handleCalculate(action)
      break
    case actions.equal:
      override = true
      handleAction(selectedAction)
      break;
    case actions.dot:
      if value.current.index(of: ".") == nil || override {
        handleDot()
      }
    default:
      break
    }
  }
  
  private func handleClear() {
    value.current = "0"
    value.previous = "0"
    selectedAction = ""
    lastAction = ""
    
    handleViewLabel()
  }
  
  private func handleABC() {
    value.current = String(Double(value.current)! * -1)
    
    handleViewLabel()
  }
  
  private func handlePercent() {
    value.current = String(Double(value.current)! / 100)
    
    handleViewLabel()
  }
  
  private func handleCalculate(_ type: String) {
    if isEmpty(value.previous) || selectedAction != type {
      value.previous = value.current
      
      override = true
    } else {
      var _value: String = ""
      
      if lastAction == type {
        switch type {
        case actions.division:
          _value = String(
            Double(value.current)! / Double(value.previous)!
          )
          break
        case actions.multiplication:
          _value = String(
            Double(value.current)! * Double(value.previous)!
          )
          break
        case actions.minus:
          _value = String(
            Double(value.current)! - Double(value.previous)!
          )
          break
        case actions.plus:
          _value = String(
            Double(value.current)! + Double(value.previous)!
          )
          break
        default:
          break
        }
      } else {
        switch type {
        case actions.division:
          _value = String(
            Double(value.previous)! / Double(value.current)!
          )
          break
        case actions.multiplication:
          _value = String(
            Double(value.previous)! * Double(value.current)!
          )
          break
        case actions.minus:
          _value = String(
            Double(value.previous)! - Double(value.current)!
          )
          break
        case actions.plus:
          _value = String(
            Double(value.previous)! + Double(value.current)!
          )
          break
        default:
          break
        }
      }
      
      if isEmpty(lastAction) || lastAction != type {
        lastAction = type
        
        value.previous = value.current
      }
      
      value.current = _value
      
      handleViewLabel()
    }
    
    selectedAction = type
  }
  
  private func handleDot() {
    if getLength(value.current) < 9 {
      if override {
        value.current = "0."
      } else {
        value.current += "."
      }
      
      override = false
      handleViewLabel()
    }
  }
  
  private func handleViewLabel() {
    if (value.current.last == ".") {
      label.text = formatString(value.current) + "."
      
      return
    }
    
    if getLength(value.current) > 12 {
      let formatter = NumberFormatter()
      formatter.numberStyle = .scientific
      formatter.positiveFormat = "0.###E+0"
      formatter.exponentSymbol = "e"
      if let scientificFormatted = formatter.string(for: Double(value.current)) {
        label.text = String(scientificFormatted)
      }
    } else {
      let _double: Double! = Double(value.current)
      var _value: String
      
      if floor(_double) == _double {
        _value = formatString(
          String(_double)
            .components(separatedBy: ".")
            .filter({ (x) -> Bool in
              return !x.isEmpty
            })[0]
        )
      } else {
        _value = formatString(String(_double))
      }
      
      label.text = _value
    }
  }
  
  private func matches(for regex: String, in text: String) -> [String] {
    do {
      let regex = try NSRegularExpression(pattern: regex)
      let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
      let finalResult = results.map({
        String(text[Range($0.range, in: text)!])
      })
      
      return finalResult
    } catch {
      return []
    }
  }
  
  private func formatString(_ text: String) -> String {
    return text.components(separatedBy: ".")
      .filter({ (x) -> Bool in
        return !x.isEmpty
      })
      .enumerated()
      .map({
        if $0.offset == 0 {
          return String(matches(for: "\\S{1,3}", in: String($0.element.reversed())).joined(separator: ",").reversed())
        }
        
        return $0.element
      }).joined(separator: ".")
  }
  
  private func getLength(_ text: String) -> Int {
    return text.components(separatedBy: ".")
      .filter({ (x) -> Bool in
        return !x.isEmpty
      }).joined(separator: "").count
  }
  
  private func isEmpty(_ value: String) -> Bool {
    return value == "0" ||
      value.isEmpty
  }
}
