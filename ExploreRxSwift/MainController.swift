import UIKit

final class MainController: UITableViewController {
    private var cellReuseIdentifier: String = "default_cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ExploreRxSwift"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
}

// MARK: - UITableViewDataSource

extension MainController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Topics.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)

        cell.textLabel?.text = Topics.allCases[indexPath.row].rawValue

        return cell
    }
}

// MARK: - UITableViewDataSource

extension MainController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topic = Topics.allCases[indexPath.row]
        let topicVC = topic.viewController
        topicVC.title = topic.rawValue
        navigationController?.pushViewController(topicVC, animated: true)
    }
}



