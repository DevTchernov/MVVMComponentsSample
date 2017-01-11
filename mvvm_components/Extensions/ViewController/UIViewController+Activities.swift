import Foundation
import UIKit
import MBProgressHUD

extension UIViewController {
	
  func showError(_ error: Error, replayAction: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
		self.hideProgress()
		let nserror = error as NSError
		let message = getErrorMessage(nserror: nserror)

    let vc = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
		vc.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { _ in
			if let completion = completion {
        completion()
      }
		}))
		self.present(vc, animated: true, completion: nil)
	}
 
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
