import UIKit
import RxSwift
import RxCocoa

final class DebounceTextFieldVC: TopicVC {
    let bag = DisposeBag()

    let textField = UITextField(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.rx.controlEvent(.allEditingEvents)
            .debounce(1, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(ConcurrentDispatchQueueScheduler(queue: .main))
            .subscribe(onNext: { [weak self] in
                Log.threadEvent("Text field has: \(self?.textField.text ?? "")")
            })
            .disposed(by: bag)

        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        textField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textField.borderStyle = .roundedRect
    }
}
