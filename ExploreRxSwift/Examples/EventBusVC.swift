import UIKit
import RxSwift
import RxCocoa

final class EventBusVC: TopicVC, OutputPresenting {
    struct TapEvent {}

    let bag: DisposeBag = .init()
    var subject: PublishSubject<TapEvent>?

    func setupExample() {
        subject = PublishSubject()
        subject?.subscribe(onNext: { [weak self] _ in
            self?.label.text = "Tapped!"
            // This could use a better solution :)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self?.label.text = ""
            })
        })
        .disposed(by: bag)

        guard let subject = subject else { return }
        subject
            .bufferWithTrigger(subject.debounce(1, scheduler: ConcurrentDispatchQueueScheduler(qos: .background)))
            .subscribe(onNext: { [weak self] array in
                self?.output("Tapped \(array.count) time/s!")
            })
        .disposed(by: bag)
    }

    @objc func buttonTapped() {
        subject?.onNext(TapEvent())

    }

    // Setup

    let contentView: UIView = .init()
    let textView: UITextView = .init()

    let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tap", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()

    let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.backgroundColor = Constant.Color.lightGray
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let spacing: CGFloat = 5

        contentView.addSubview(button)
        contentView.addSubview(label)

        button.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 50),
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing),
            label.heightAnchor.constraint(equalToConstant: 50),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -spacing)
        ])

        setupExample()
    }
}
