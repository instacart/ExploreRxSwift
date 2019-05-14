import UIKit
import RxSwift

final class SimplePoolingVC: TopicVC, OutputPresenting {
    let contentView: UIView = .init()
    let textView: UITextView = .init()

    // let bag: DisposeBag = .init()

    var disposable: Disposable? {
        didSet {
            oldValue?.dispose()
        }
    }

    deinit {
        disposable?.dispose()
    }

    @objc func startSimplePooling() {
        output("Start simple pooling")

        disposable = Observable<Int>
            .interval(0.5, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .take(20)
            .filter {
                $0.isMultiple(of: 2)
            }
            .map { [weak self] value -> Int in
                self?.output("Value from map \(value)")
                return value
            }
            .do(onNext: { [weak self] in
                self?.output("do onNext \($0)")
            }, onSubscribed: { [weak self] in
                self?.output("subscribed")
            })
            .subscribe { [weak self] event in
                switch event {
                case .next(let value): self?.output("Value \(value)")
                case .error(let error): self?.output("Error", error)
                case .completed: self?.output("Completed", self ?? "retained self gone")
                }
        }
        //.disposed(by: bag)
    }

    @objc func dispose() {
        output("Dispose")

        disposable?.dispose()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let firstButton = UIButton(type: .system)
        firstButton.setTitle("Start simple pooling", for: .normal)
        firstButton.translatesAutoresizingMaskIntoConstraints = false
        firstButton.addTarget(self, action: #selector(startSimplePooling), for: .touchUpInside)
        contentView.addSubview(firstButton)
        firstButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        firstButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        firstButton.bottomAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

        let secondButton = UIButton(type: .system)
        secondButton.setTitle("Dispose", for: .normal)
        secondButton.translatesAutoresizingMaskIntoConstraints = false
        secondButton.addTarget(self, action: #selector(dispose), for: .touchUpInside)
        contentView.addSubview(secondButton)
        secondButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        secondButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        secondButton.topAnchor.constraint(equalTo: firstButton.bottomAnchor).isActive = true
    }
}
