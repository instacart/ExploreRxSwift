import UIKit
import RxSwift

final class SimplePollingVC: TopicVC, OutputPresenting {
    let contentView: UIView = .init()
    let textView: UITextView = .init()

    // let bag: DisposeBag = .init()
    // var disposable: Disposable?

    @objc func startSimplePolling() {
        
    }

    @objc func dispose() {
        output("Dispose")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let firstButton = UIButton(type: .system)
        firstButton.setTitle("Start simple polling", for: .normal)
        firstButton.translatesAutoresizingMaskIntoConstraints = false
        firstButton.addTarget(self, action: #selector(startSimplePolling), for: .touchUpInside)
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
