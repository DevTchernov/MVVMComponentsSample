//
//  ViewController.swift
//  mvvm_components
//
//  Created by Andrey Chernov on 09.01.17.
//  Copyright © 2017 Andrey Chernov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIRxComponentsViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

class RxViewModel: NSObject, DisposableContainer {
  var disposeBag: DisposeBag! = DisposeBag()
  private let scheduler = SerialDispatchQueueScheduler.init(qos: .userInteractive)
  func observeInput<T>( _ observable: Observable<T>, onNext: ((T) -> Void)? = nil, onError: ( (Error) -> Void)? = nil, onCompleted: (() -> Void)? = nil ) {
    observable
      .observeOn(self.scheduler)
      .subscribe(
        onNext: onNext,
        onError: onError,
        onCompleted: {
          onCompleted?()
      },
        onDisposed: nil)
      .addDisposableTo(self.disposeBag)
  }
}

class AuthViewModel: RxViewModel {
  //Enums
  enum DataType {
    case Username(String)
    case Password(String)
  }
  enum State {
    case Initial
    case InvalidInput(DataType)
    case ValidInput(DataType)
    case Error(Error)
    case Success
  }
  
  enum Action {
    case ChangeData(DataType)
    case Confirm
    enum Social {
      case Facebook
      case VKontakte
      case Twitter
      //case ...
    }
    case RegisterWith(Social)
  }
  
  //Variables
  private var currentUsername = Variable<String>("")
  private var currentPassword = Variable<String>("")
  private var currentState = Variable<State>(.Initial)
  
  func observeData() -> Observable<DataType> {
    return Observable.of(
      currentUsername.asObservable().map{ DataType.Username($0) },
      currentPassword.asObservable().map{ DataType.Password($0) }).merge()
  }
  
  func observeState() -> Observable<State> {
    return self.currentState.asObservable()
  }
  
  func accept(action: Action) {
    switch(action) {
    case .Confirm:
      break
    case .ChangeData(let dataType):
      switch (dataType) {
      case .Password(let text):
        self.currentPassword.value = text
        break
      case .Username(let text):
        self.currentUsername.value = text
        break
      }
      break
    case .RegisterWith(let social):
      
      break
    }
  }
  
  //или вот так?
  func bindActions(driver: Driver<Action>) {
    driver.drive(onNext: self.accept, onCompleted: nil, onDisposed: nil).addDisposableTo(self.disposeBag)
  }
}

protocol DisposableContainer {
  var disposeBag: DisposeBag! { get }
}
extension DisposableContainer {
  func observeAction<T>( _ observable: Observable<T>, onNext: ((T) -> Void)? = nil, onError: ( (Error) -> Void)? = nil, onCompleted: (() -> Void)? = nil ) {
    observable
      .observeOn(MainScheduler.instance)
      .subscribe(
        onNext: onNext,
        onError: onError,
        onCompleted: {
          onCompleted?()
      },
        onDisposed: nil)
      .addDisposableTo(self.disposeBag)
  }
}

class UIRxView: UIView, DisposableContainer {
  var disposeBag:DisposeBag! = DisposeBag()
  deinit {
    self.disposeBag = nil
  }
}

class AuthView: UIRxView { //has dispose bag
  @IBOutlet weak var username: UITextField!
  @IBOutlet weak var password: UITextField!
  
 	func setup(with viewModel: AuthViewModel) {
    //subscription
    self.observeAction(viewModel.observeData(), onNext: { data in
      switch(data) {
      case .Username(let text):
        self.username?.text = text
        break
      case .Password(let text):
        self.password?.text = text
        break
      }
    })
    //commands
    if let username = self.username {
      viewModel.bindActions(driver: username.rx.text.asDriver().map({
        .ChangeData(
        AuthViewModel.DataType.Username($0 ?? "")
        )
      }))
    }
    if let password = self.password {
      viewModel.bindActions(driver: password.rx.text.asDriver().map({
        .ChangeData(
          AuthViewModel.DataType.Password($0 ?? "")
        )
      }))
    }
 	}
}

class MVVMRxComponent: NSObject {
  func setup() {
  }
}

class AuthComponent: MVVMRxComponent {
  @IBOutlet weak var authView: AuthView!
  var viewModel = AuthViewModel()
  override func setup() {
    super.setup()
    self.authView?.setup(with: viewModel)
  }
}

class UIRxViewController : UIViewController, DisposableContainer {
  var disposeBag:DisposeBag! = DisposeBag()
  deinit {
    self.disposeBag = nil
  }
}

class UIRxComponentsViewController: UIRxViewController {
  @IBOutlet var components: [MVVMRxComponent]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    for component in components {
      component.setup()
    }
  }
}

class MYAuthVC: UIRxComponentsViewController {
  override func viewDidLoad() {
    super.viewDidLoad()		
  }
}
