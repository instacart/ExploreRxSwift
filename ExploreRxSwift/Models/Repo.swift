struct Repo: Codable {
    let name: String
    let fullName: String
    let stargazersCount: Int
    let language: String?
    let description: String?
}

struct Release: Codable {
    let name: String
}
