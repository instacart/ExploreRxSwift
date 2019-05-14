import Foundation
import UIKit

protocol OutputPresenting: class {
    var view: UIView! { get set }
    var contentView: UIView { get }
    var textView: UITextView { get }
    func output(_ items: Any...)
}

extension OutputPresenting {
    func setupViews() {
        textView.isEditable = false
        textView.font = UIFont(name: "Menlo-Regular", size: 10)
        textView.backgroundColor = Constant.Color.lightGray

        view.addSubview(textView)
        view.addSubview(contentView)

        textView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: textView.bottomAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    var textOutput: String {
        get {
            return textView.text
        }
        set {
            textView.text = newValue

            let bottom = NSMakeRange(newValue.count - 1, 1)
            textView.scrollRangeToVisible(bottom)
        }
    }

    func output(_ items: Any...) {
        Log.threadEvent(items)
        let currentThreadDescription = "\(Thread.current):\n"
        DispatchQueue.main.async {
            self.textOutput += currentThreadDescription + items.flatMap({ String(describing: $0) }) + "\n\n"
        }
    }
}
