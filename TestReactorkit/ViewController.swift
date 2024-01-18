//
//  ViewController.swift
//  TestReactorkit
//
//  Created by Leojin on 2024/01/14.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

final class ViewController: UIViewController, StoryboardView {
    
    @IBOutlet weak var increseButton: UIButton!
    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bind(reactor: ViewReactor) {
        increseButton.rx.tap
            .map { Reactor.Action.increase }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        decreaseButton.rx.tap
            .map { Reactor.Action.decrease }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.value }
            .distinctUntilChanged()
            .map { "\($0)"}
            .bind(to: valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$alertMessage)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] message in
                let alertController = UIAlertController(
                    title: nil,
                    message: message,
                    preferredStyle: .alert
                    )
                alertController.addAction(UIAlertAction(
                    title: "OK",
                    style: .default,
                    handler: nil
                ))
                self?.present(alertController, animated: true)
            })
            .disposed(by: disposeBag)
        
        
    }
}

