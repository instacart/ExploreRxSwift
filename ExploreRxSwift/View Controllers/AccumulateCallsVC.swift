import UIKit
import RxSwift
import RxCocoa

final class AccumulateCallsVC: TopicVC {
    let bag = DisposeBag()

    let button: UIButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()

        button.setTitle("Tap", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        button.rx.tap
            .map { () -> Int in
                Log.threadEvent("Tapped")
                return 1
            }
            .buffer(timeSpan: 2, count: Int.max, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
//            .filter {
//                $0.count > 0
//            }
            .subscribe { event in
                switch event {
                case .next(let value): Log.threadEvent("Tapped \(value.count) time/s")
                case .error(let error): Log.threadEvent(error)
                case .completed: Log.threadEvent("Compelted")
                }
            }
            .disposed(by: bag)
    }
}
