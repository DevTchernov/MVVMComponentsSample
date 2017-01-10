//
//  SSViewController+AlertController.swift
//  StaffSmart
//
//  Created by Artem Ryzhov on 07.07.16.
//  Copyright © 2016 Artem Ryzhov. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIViewController {
	
  func showError(_ error: Error, replayAction: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
		self.hideProgress()
		let nserror = error as NSError
		let message = getErrorMessage(nserror: nserror)
    /*
    if let completion = replayAction,
      nserror.domain == NSURLErrorDomain &&
      (nserror.code == NSURLErrorNetworkConnectionLost ||
      nserror.code == NSURLErrorNotConnectedToInternet) {
        NoInternetViewController.showNoInternet(view: self.view, completeBlock: completion)
        return
    }*/

		let vc = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
		vc.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { _ in
			if let completion = completion {
        completion()
      }
		}))
		self.present(vc, animated: true, completion: nil)
	}
  /*
  
  func showAuthorizationError(_ error: Error, errorView: ErrorView, fields:[String: NOTextField]? = nil, completion: (() -> Void)? = nil) {
    self.hideProgress()
    let nserror = error as NSError
    let message = getErrorMessage(nserror: nserror)
    
    errorView.showError(withText: message)
    
    if let field = nserror.userInfo["field"] as? String, let textField = fields?[field] {
      textField.showError()
    }
  }*/
  
  func getErrorMessage(nserror: NSError) -> String {
    var message = nserror.localizedDescription
  
    if nserror.domain == NSURLErrorDomain {
      switch(nserror.code) {
      case NSURLErrorCannotFindHost:
        message = "Can not find remote hots"
        break
      case NSURLErrorCannotConnectToHost:
        message = "Can not connect to host"
        break
      case NSURLErrorNetworkConnectionLost, NSURLErrorNotConnectedToInternet:
        message = "Нет сети"
        break
      default:
        break
      }
    }
    
    
    //if nserror.domain == UserServiceImp.ProfileErrors.Domain {
    //message = nserror.userInfo["description"] as! String!
    //}
    if let errorText = nserror.userInfo["description"] as? String {
      message = errorText
    }
    
    return message
  }
	
	func showProgress() {
		MBProgressHUD.showAdded(to: self.view, animated: true)
	}
	
	func hideProgress() {
		MBProgressHUD.hide(for: self.view, animated: true)
	}
	
	func isPresented() -> Bool {
		return self.isViewLoaded && (self.view.window != nil)
	}
}
