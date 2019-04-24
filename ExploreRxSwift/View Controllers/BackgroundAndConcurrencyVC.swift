import UIKit
import RxSwift
import Foundation

final class BackgroundAndConcurrencyVC: TopicVC {
    let bag = DisposeBag()
    lazy var observable: Observable<Bool> = Observable
        .just(true)
        .do(onSubscribed: {
            Log.threadEvent("subscribed")
        })
        .map {
            Log.threadEvent("Before sleep in background")
            sleep(5)
            return $0
        }
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .observeOn(ConcurrentDispatchQueueScheduler(queue: .main)).map { (value: Bool) -> Bool in
            Log.threadEvent("Before sleep in main")
            sleep(5)
            return value
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton(type: .system)
        button.setTitle("Tap", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        view.addSubview(button)
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    @objc func buttonTapped() {
        let subscription = observable.subscribe(onNext:{ event in
            Log.threadEvent("On next \(event)")
        })
        subscription.disposed(by: bag)
    }
}

