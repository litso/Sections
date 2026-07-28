import Sections
import UIKit

final class TableViewController: UITableViewController {

    private struct Friend: Equatable {
        let name: String
        let symbolName: String
        let color: UIColor

        static func == (lhs: Friend, rhs: Friend) -> Bool {
            lhs.name == rhs.name && lhs.symbolName == rhs.symbolName
        }
    }

    private enum Row: Equatable {
        case profile
        case settings
        case friend(Friend)
        case authentication
    }

    private let friends = [
        Friend(name: "Alice Chen", symbolName: "person.crop.circle.fill", color: .systemPink),
        Friend(name: "Ben Carter", symbolName: "person.crop.circle.fill", color: .systemBlue),
        Friend(name: "Maya Patel", symbolName: "person.crop.circle.fill", color: .systemOrange)
    ]

    private var isLoggedIn = true
    private var sections = Sections<Row>()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Profile"
        navigationItem.largeTitleDisplayMode = .never
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 64
        tableView.cellLayoutMarginsFollowReadableWidth = true

        rebuildSections()
    }

    private func rebuildSections() {
        let loggedIn = isLoggedIn
        let friends = friends

        sections = SectionBuilder<Row>(initialValues: [])
            .addSections { _ in
                let rows: [Row] = loggedIn ? [.profile, .settings] : [.settings]
                return [Section(name: "Account", rows: rows)]
            }
            .addSections { _ in
                guard loggedIn else { return [] }
                return [Section(name: "Friends", rows: friends.map(Row.friend))]
            }
            .addSections { _ in
                [Section(name: "Actions", rows: [.authentication])]
            }
            .sections
    }

    private func setLoggedIn(_ loggedIn: Bool) {
        guard loggedIn != isLoggedIn else { return }

        isLoggedIn = loggedIn
        rebuildSections()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].rows.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].name
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? ProfileTableViewCell else {
            return UITableViewCell()
        }

        switch sections[indexPath.section].rows[indexPath.row] {
        case .profile:
            cell.configure(
                title: "Robert Manson",
                subtitle: "View profile",
                symbolName: "person.crop.circle.fill",
                symbolColor: .systemBlue,
                prominence: .profile
            )
        case .settings:
            cell.configure(
                title: "Settings",
                symbolName: "gearshape.fill",
                symbolColor: .secondaryLabel
            )
        case .friend(let friend):
            cell.configure(
                title: friend.name,
                symbolName: friend.symbolName,
                symbolColor: friend.color
            )
        case .authentication:
            cell.configure(
                title: isLoggedIn ? "Log Out" : "Log In",
                symbolName: isLoggedIn ? "rectangle.portrait.and.arrow.right" : "rectangle.portrait.and.arrow.forward",
                symbolColor: isLoggedIn ? .systemRed : .systemBlue,
                textColor: isLoggedIn ? .systemRed : .systemBlue
            )
        }

        return cell
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard sections[indexPath.section].rows[indexPath.row] == .authentication else { return }
        setLoggedIn(!isLoggedIn)
    }
}

private final class ProfileTableViewCell: UITableViewCell {

    enum Prominence {
        case standard
        case profile
    }

    static let reuseIdentifier = "ProfileTableViewCell"

    private let symbolBackgroundView = UIView()
    private let symbolImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let labelsStackView = UIStackView()
    private var symbolSizeConstraint: NSLayoutConstraint?
    private var minimumHeightConstraint: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        accessoryType = .disclosureIndicator

        symbolBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        symbolBackgroundView.clipsToBounds = true
        contentView.addSubview(symbolBackgroundView)

        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        symbolImageView.contentMode = .scaleAspectFit
        symbolBackgroundView.addSubview(symbolImageView)

        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.numberOfLines = 0

        subtitleLabel.adjustsFontForContentSizeCategory = true
        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0

        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.axis = .vertical
        labelsStackView.alignment = .leading
        labelsStackView.spacing = 2
        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(subtitleLabel)
        contentView.addSubview(labelsStackView)

        let symbolSizeConstraint = symbolBackgroundView.widthAnchor.constraint(equalToConstant: 40)
        let minimumHeightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        self.symbolSizeConstraint = symbolSizeConstraint
        self.minimumHeightConstraint = minimumHeightConstraint

        NSLayoutConstraint.activate([
            symbolBackgroundView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            symbolBackgroundView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            symbolSizeConstraint,
            symbolBackgroundView.heightAnchor.constraint(equalTo: symbolBackgroundView.widthAnchor),

            symbolImageView.leadingAnchor.constraint(equalTo: symbolBackgroundView.leadingAnchor, constant: 7),
            symbolImageView.trailingAnchor.constraint(equalTo: symbolBackgroundView.trailingAnchor, constant: -7),
            symbolImageView.topAnchor.constraint(equalTo: symbolBackgroundView.topAnchor, constant: 7),
            symbolImageView.bottomAnchor.constraint(equalTo: symbolBackgroundView.bottomAnchor, constant: -7),

            labelsStackView.leadingAnchor.constraint(equalTo: symbolBackgroundView.trailingAnchor, constant: 14),
            labelsStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.trailingAnchor),
            labelsStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelsStackView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 10),
            labelsStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            minimumHeightConstraint
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.textColor = .label
        subtitleLabel.isHidden = true
    }

    func configure(
        title: String,
        subtitle: String? = nil,
        symbolName: String,
        symbolColor: UIColor,
        textColor: UIColor = .label,
        prominence: Prominence = .standard
    ) {
        let isProfile = prominence == .profile
        let symbolPointSize: CGFloat = isProfile ? 34 : 22

        titleLabel.text = title
        titleLabel.textColor = textColor
        titleLabel.font = isProfile
            ? .preferredFont(forTextStyle: .title3).bold()
            : .preferredFont(forTextStyle: .body)

        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = subtitle == nil

        symbolImageView.image = UIImage(
            systemName: symbolName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: symbolPointSize, weight: .regular)
        )
        symbolImageView.tintColor = symbolColor
        symbolBackgroundView.backgroundColor = symbolColor.withAlphaComponent(0.12)

        let symbolSize: CGFloat = isProfile ? 58 : 40
        symbolSizeConstraint?.constant = symbolSize
        minimumHeightConstraint?.constant = isProfile ? 82 : 60
        symbolBackgroundView.layer.cornerRadius = symbolSize / 2
    }
}

private extension UIFont {
    func bold() -> UIFont {
        UIFont(descriptor: fontDescriptor.withSymbolicTraits(.traitBold) ?? fontDescriptor, size: pointSize)
    }
}
