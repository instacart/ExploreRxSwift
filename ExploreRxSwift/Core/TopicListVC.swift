import UIKit

final class TopicListVC: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ExploreRxSwift"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(Cell.self, forCellReuseIdentifier: Cell.id)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
    }
}

// MARK: - UITableViewDataSource

extension TopicListVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Topics.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.id, for: indexPath)

        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = Topics.allCases[indexPath.row].rawValue

        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = Topics.allCases[indexPath.row].subtitle

        return cell
    }
}

// MARK: - UITableViewDataSource

extension TopicListVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topic = Topics.allCases[indexPath.row]
        let topicVC = topic.viewController
        topicVC.title = topic.rawValue
        navigationController?.pushViewController(topicVC, animated: true)
    }
}

// MARK: -

private class Cell: UITableViewCell {
    static let id: String = "default_cell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



