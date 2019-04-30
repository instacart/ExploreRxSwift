import UIKit
import RxSwift

final class SimpleAndIncreasingPooling: TopicVC {

    var disposable: Disposable? {
        didSet {
            oldValue?.dispose()
        }
    }

    deinit {
        disposable?.dispose()
    }

    @objc func startSimplePooling() {
        Log.threadEvent("Start simple pooling")

        disposable = Observable<Int>
            .interval(0.5, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .take(20)
            .filter {
                $0.isMultiple(of: 2)
            }
            .map { value -> Int in
                Log.threadEvent("Value from map \(value)")
                return value
            }
            .do(onNext: {
                Log.threadEvent("do onNext \($0)")
            }, onSubscribed: {
                Log.threadEvent("subscribed")
            })
            .subscribe { [weak self] event in
                switch event {
                case .next(let value): Log.threadEvent("Value \(value)")
                case .error(let error): Log.threadEvent("Error", error)
                case .completed: Log.threadEvent("Completed", self)
                }
            }
            //.disposed(by: bag)
    }

    @objc func startPoolingWithIncreasingDelay() {
        Log.threadEvent("Start pooling with increasing delay")
    }

    @objc func dispose() {
        Log.threadEvent("Dispose")

        disposable?.dispose()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let firstButton = UIButton(type: .system)
        firstButton.setTitle("Simple pooling", for: .normal)
        firstButton.translatesAutoresizingMaskIntoConstraints = false
        firstButton.addTarget(self, action: #selector(startSimplePooling), for: .touchUpInside)
        view.addSubview(firstButton)
        firstButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.padding).isActive = true
        firstButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.padding).isActive = true
        firstButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constant.padding).isActive = true

        let secondButton = UIButton(type: .system)
        secondButton.setTitle("Pooling with increased delay", for: .normal)
        secondButton.translatesAutoresizingMaskIntoConstraints = false
        secondButton.addTarget(self, action: #selector(startPoolingWithIncreasingDelay), for: .touchUpInside)
        view.addSubview(secondButton)
        secondButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.padding).isActive = true
        secondButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.padding).isActive = true
        secondButton.topAnchor.constraint(equalTo: firstButton.bottomAnchor, constant: Constant.padding).isActive = true

        let thirdButton = UIButton(type: .system)
        thirdButton.setTitle("Dispose", for: .normal)
        thirdButton.translatesAutoresizingMaskIntoConstraints = false
        thirdButton.addTarget(self, action: #selector(dispose), for: .touchUpInside)
        view.addSubview(thirdButton)
        thirdButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.padding).isActive = true
        thirdButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.padding).isActive = true
        thirdButton.topAnchor.constraint(equalTo: secondButton.bottomAnchor, constant: Constant.padding).isActive = true
    }

    private let bag = DisposeBag()

    private enum Constant {
        static let padding: CGFloat = 20
    }
}
