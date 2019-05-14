import UIKit
import RxSwift
import RxCocoa

final class FormValidationVC: TopicVC, OutputPresenting {
    let contentView: UIView = .init()
    let textView: UITextView = .init()

    let bag: DisposeBag = .init()

    let emailField: UITextField = .init()
    let passwordField: UITextField = .init()
    let numberField: UITextField = .init()

    func setupExample() {
        Observable.combineLatest(emailField.rx.text.orEmpty.asObservable(),
                                 passwordField.rx.text.orEmpty.asObservable(),
                                 numberField.rx.text.orEmpty.asObservable(),
                                 resultSelector: { (email, password, number) -> Bool in // Always specify return type!!!
                                    let haveEmail = email.count > 0
                                    let havePassword = password.count > 0
                                    let haveNumber = number.count > 0
                                    return haveEmail && havePassword && haveNumber
        })
        .subscribe { [weak self] event in
            switch event {
            case .next(let value): self?.output("Value \(value)")
            case .error(let error): self?.output("Error", error)
            case .completed: self?.output("Completed", self ?? "retained self gone")
            }
        }
        .disposed(by: bag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.textContentType = .emailAddress
        emailField.keyboardType = .emailAddress
        passwordField.isSecureTextEntry = true
        passwordField.textContentType = .password
        numberField.textContentType = .telephoneNumber
        numberField.keyboardType = .numberPad

        emailField.backgroundColor = Constant.Color.lightGray
        passwordField.backgroundColor = Constant.Color.lightGray
        numberField.backgroundColor = Constant.Color.lightGray
        let stackView = UIStackView(arrangedSubviews: [emailField, passwordField, numberField])
        let spacing: CGFloat = 5
        stackView.spacing = spacing
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)

        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailField.becomeFirstResponder()
        setupExample()
    }
}
