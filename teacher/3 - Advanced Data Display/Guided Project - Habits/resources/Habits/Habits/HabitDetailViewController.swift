//
// HabitDetailViewController.swift
// Habits
//


import UIKit

class HabitDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    // keep track of async tasks so they can be cancelled when appropriate.
    var habitStatisticsRequestTask: Task<Void, Never>? = nil
    deinit { habitStatisticsRequestTask?.cancel() }
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item.ID>

    enum ViewModel {
        enum Section: Hashable {
            case leaders(count: Int)
            case remaining
        }

        enum Item: Identifiable, Comparable {
            case single(_ stat: UserCount)
            case multiple(_ stats: [UserCount])
            
            var id: String {
                switch self {
                case .single(let stat):
                    return "single:\(stat.user.id)"
                case .multiple(let stats):
                    return "multiple:\(stats.map(\.user.id))"
                }
            }
            
            static func < (lhs: Item, rhs: Item) -> Bool {
                switch (lhs, rhs) {
                case (.single(let lCount), .single(let rCount)):
                    return lCount.count < rCount.count
                case (.multiple(let lCounts), .multiple(let rCounts)):
                    return lCounts.first!.count < rCounts.first!.count
                case (.single, .multiple):
                    return false
                case (.multiple, .single):
                    return true
                }
            }
        }
    }

    struct Model {
        var habitStatistics: HabitStatistics?
        var userCounts: [UserCount] {
            habitStatistics?.userCounts ?? []
        }
    }

    var dataSource: DataSourceType!
    var model = Model()
    var items: [ViewModel.Item] = []

    var habit: Habit!

    var updateTimer: Timer?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init?(coder: NSCoder, habit: Habit) {
        self.habit = habit
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never

        nameLabel.text = habit.name
        categoryLabel.text = habit.category.name
        infoLabel.text = habit.info
        
        dataSource = createDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createLayout()

        update()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        update()

        updateTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.update()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        updateTimer?.invalidate()
        updateTimer = nil
    }

    func createDataSource() -> DataSourceType {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ViewModel.Item.ID> { [weak self] cell, indexPath, itemIdentifier in
            guard let self,
                  let grouping = items.first(where: { $0.id == itemIdentifier}) else { 
                return
            }
            var content = UIListContentConfiguration.subtitleCell()
            content.prefersSideBySideTextAndSecondaryText = true
            switch grouping {
            case .single(let userStat):
                content.text = userStat.user.name
                content.secondaryText = "\(userStat.count)"
                content.textProperties.font = .preferredFont(forTextStyle: .headline)
                content.secondaryTextProperties.font = .preferredFont(forTextStyle: .body)
            default:
                break
            }
            cell.contentConfiguration = content
        }
        return DataSourceType(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }

    func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 12)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)

        return UICollectionViewCompositionalLayout(section: section)
    }

    func update() {
        habitStatisticsRequestTask?.cancel()
        habitStatisticsRequestTask = Task {
            if let statistics = try? await HabitStatisticsRequest(habitNames: [habit.name]).send(), statistics.count > 0 {
                self.model.habitStatistics = statistics[0]
            } else {
                self.model.habitStatistics = nil
            }
            self.updateCollectionView()
            
            habitStatisticsRequestTask = nil
        }
    }

    func updateCollectionView() {
        items = (self.model.habitStatistics?.userCounts.map { ViewModel.Item.single($0) } ?? []).sorted(by: >)

        dataSource.applySnapshotUsing(sectionIDs: [.remaining], itemsBySection: [.remaining: items.map(\.id)])
    }

}
