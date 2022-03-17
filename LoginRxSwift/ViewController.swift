//
//  ViewController.swift
//  LoginRxSwift
//
//  Created by Juma on 1/5/22.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    private let loginviewModel = LoginViewModel()
    private let disposBag = DisposeBag()
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var buttonText: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.becomeFirstResponder()
        
        usernameTextField.rx.text.map { $0 ?? "" }.bind(to: loginviewModel.usernamePublisherSubject).disposed(by: disposBag)
        passwordTextField.rx.text.map { $0 ?? "" }.bind(to: loginviewModel.passwordPublisherSubject).disposed(by: disposBag)
        
        loginviewModel.isValidThis().bind(to: buttonText.rx.isEnabled).disposed(by: disposBag)
        loginviewModel.isValidThis().map { $0 ? 1 : 0.1 }.bind(to: buttonText.rx.alpha).disposed(by: disposBag)
    }
    

    @IBAction func buttonTap(_ sender: UIButton) {
        print("button tapped!! ")
    }
    
}


class LoginViewModel {
    let usernamePublisherSubject = PublishSubject<String>()
    let passwordPublisherSubject = PublishSubject<String>()
    
    func isValidThis() -> Observable<Bool> {
        Observable.combineLatest(usernamePublisherSubject.asObserver(),                   passwordPublisherSubject.asObserver()).map { (username, password) in
            return username.count > 3 && password.count > 3
        }
        .startWith(false)
    }
}
