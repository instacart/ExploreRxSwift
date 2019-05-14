import UIKit
import RxSwift
import RxCocoa

final class DebounceTextFieldVC: TopicVC, OutputPresenting {
    let contentView: UIView = .init()
    let textView: UITextView = .init()
    
    let bag: DisposeBag = .init()

    let textField = UITextField(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.placeholder = "Start typing"
        textField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textField)
        textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textField.borderStyle = .roundedRect

        textField.rx.controlEvent(.allEditingEvents)
            .debounce(1, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(ConcurrentDispatchQueueScheduler(queue: .main))
            .subscribe(onNext: { [weak self] in
                self?.output("Field text is: \(self?.textField.text ?? "")")
            })
            .disposed(by: bag)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
}
