import UIKit

class TopicVC: UIViewController {
    override func loadView() {
        guard let outputPresentingVC = self as? OutputPresenting else {
            view = UIView()
            return
        }
        view = UIView()
        outputPresentingVC.setupViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
