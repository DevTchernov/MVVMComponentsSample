//
//  NOTextField.swift
//  NetOptika
//
//  Created by Smallkot on 31.10.16.
//  Copyright © 2016 icerockdev. All rights reserved.
//

import UIKit

enum FieldState {
	case Error
	case NoActive
	case Active
	var lineColor: UIColor {
		get {
			switch self {
			case .Active:
				return UIColor(named: .sky)
			case .Error:
				return UIColor(named: .red)
			case .NoActive:
				return UIColor(named: .grey)
			}
		}
	}

	var textColor: UIColor {
		get {
			switch self {
			case .Active:
				return UIColor(named: .greyBlue)
			case .Error:
				return UIColor(named: .red)
			case .NoActive:
				return UIColor(named: .greyBlue)
			}
		}
	}
}

class NOTextField: UILoadableView {

  @IBOutlet weak var textField: UITextField!
  @IBOutlet private weak var errorImage: UIImageView!
  @IBOutlet private weak var line: UIView!
  
  var textFieldDidBeginEditing: ((NOTextField) -> Void)?
  var textFieldDidEndEditing: ((NOTextField) -> Void)?
  var textFieldShouldReturn: ((NOTextField) -> Bool)?
  
  enum KeyboardTypes: String {
    case number = "number"
    case phone = "phone"
    case text = "text"
    case email = "email"
    
    func textFieldType() -> UIKeyboardType {
      switch(self) {
      case .number:
        return UIKeyboardType.numberPad
      case .phone:
        return UIKeyboardType.phonePad
      case .text:
        return UIKeyboardType.alphabet
      case .email:
        return UIKeyboardType.emailAddress
      }
    }
  }
  
  override func becomeFirstResponder() -> Bool {
    return textField.becomeFirstResponder()
  }
  
  override func resignFirstResponder() -> Bool {
    return textField.resignFirstResponder()
  }
  
  @IBInspectable var text: String? {
    get {
      return textField.text
    }
    set {
      textField.text = newValue
    }
  }

  @IBInspectable var placeholder: String? {
    get {
      return textField.placeholder
    }
    set {
      textField.placeholder = newValue
    }
  }
  
  @IBInspectable var isPasswordField: Bool {
    get {
      return textField.isSecureTextEntry
    }
    set {
      textField.isSecureTextEntry = newValue
    }
  }

	//И переключение между ними
	var currentState: FieldState = .NoActive {
		//Заодно можно добавлять логику на переключение в willSet например
		didSet {
			self.setParam(lineBackgroundColor: currentState.lineColor, errorImageHidden: currentState != .Error, textColor: currentState.textColor)
		}
	}

	override var nibName: String { get { return "NOTextField" } }

	override func awakeFromNib() {
		super.awakeFromNib()
		textField.delegate = self
		hideError()
	}

  func showError() {
		currentState = .Error
    //setParam(lineBackgroundColor: colorError, errorImageHidden: false, textColor: colorError)
  }

  func hideError() {
		currentState = .NoActive
    //setParam(lineBackgroundColor: colorLine, errorImageHidden: true, textColor: colorText)
  }

  func activeStyle() {
		currentState = .Active
    //setParam(lineBackgroundColor: colorLineActive, errorImageHidden: true, textColor: colorText)
  }

  func noActiveStyle() {
		currentState = .NoActive
    //setParam(lineBackgroundColor: colorLine, errorImageHidden: true, textColor: colorText)
  }

  func setParam(lineBackgroundColor: UIColor, errorImageHidden: Bool, textColor: UIColor) {
    line.backgroundColor = lineBackgroundColor
    errorImage.isHidden = errorImageHidden
    textField.textColor = textColor
  }
}

extension NOTextField: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    activeStyle()
    guard let textFieldDidBeginEditing = self.textFieldDidBeginEditing else {
      return
    }
    textFieldDidBeginEditing(self)
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    noActiveStyle()
    guard let textFieldDidEndEditing = self.textFieldDidEndEditing else {
      return
    }
    textFieldDidEndEditing(self)
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let textFieldShouldReturn = self.textFieldShouldReturn {
      return textFieldShouldReturn(self)
    }
    textField.resignFirstResponder()
    return true
  }
}
