import UIKit
import RxSwift
import RxCocoa

final class AccumulateCallsVC: TopicVC, OutputPresenting {
    let contentView: UIView = .init()
    let textView: UITextView = .init()
    
    let bag = DisposeBag()

    let button: UIButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()

        button.setTitle("Tap", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        button.rx.tap
            .map { [weak self] () -> Int in
                self?.output("Tapped")
                return 1
            }
            .buffer(timeSpan: 2, count: Int.max, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
//            .filter {
//                $0.count > 0
//            }
            .subscribe { [weak self] event in
                switch event {
                case .next(let value): self?.output("Tapped \(value.count) time/s")
                case .error(let error): self?.output(error)
                case .completed: self?.output("Compelted")
                }
            }
            .disposed(by: bag)
    }
}
