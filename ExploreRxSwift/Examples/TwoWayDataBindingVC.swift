import UIKit
import RxSwift
import RxCocoa

final class TwoWayDataBindingVC: TopicVC, OutputPresenting {
    let contentView: UIView = .init()
    let textView: UITextView = .init()

    let firstField: UITextField = .init()
    let secondField: UITextField = .init()

    let bag: DisposeBag = .init()
    var subject: PublishSubject<String>?

    func setupExample() {
        // Not a good use case!

        firstField.addTarget(self, action: #selector(changeHandler(_:)), for: .editingChanged)
        secondField.addTarget(self, action: #selector(changeHandler(_:)), for: .editingChanged)

        subject = PublishSubject()
        subject?.subscribe { [weak self] event in
            switch event {
            case .next(let element): self?.output(element)
            case .error(let error): self?.output(error)
            case .completed: self?.output("Completed")
            }
        }
        .disposed(by: bag)
    }

    @objc func changeHandler(_ sender: UITextField) {
        subject?.onNext((firstField.text ?? "") + (secondField.text ?? ""))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.addSubview(firstField)
        contentView.addSubview(secondField)
        firstField.backgroundColor = Constant.Color.lightGray
        secondField.backgroundColor = Constant.Color.lightGray

        let stackView = UIStackView(arrangedSubviews: [firstField, secondField])
        let spacing: CGFloat = 5
        stackView.spacing = spacing
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 100).isActive = true

        setupExample()
    }
}
