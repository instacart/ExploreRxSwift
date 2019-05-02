import UIKit
import RxSwift
import Foundation

final class BackgroundAndConcurrencyVC: TopicVC, OutputPresenting {
    let contentView: UIView = .init()
    let textView: UITextView = .init()

    let bag = DisposeBag()
    lazy var observable: Observable<Bool> = Observable
        .just(true)
        .do(onSubscribed: { [weak self] in
            self?.output("subscribed")
        })
        .map { [weak self] in
            self?.output("Before sleep on background thread")
            sleep(2)
            return $0
        }
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .observeOn(ConcurrentDispatchQueueScheduler(queue: .main)).map { [weak self] (value: Bool) -> Bool in
            self?.output("Before sleep no main thread")
            sleep(2)
            return value
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton(type: .system)
        button.setTitle("Start", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        contentView.addSubview(button)
        button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }

    @objc func buttonTapped() {
        let subscription = observable.subscribe(onNext:{ [weak self] event in
            self?.output("On next \(event)")
        })
        subscription.disposed(by: bag)
    }
}

