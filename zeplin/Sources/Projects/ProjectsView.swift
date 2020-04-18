import SnapKit
import UIKit
import RxSwift
import RxCocoa
import Reusable

final class ProjectsView: UIView {
  // MARK: - Properties
  var bag = DisposeBag()
  
  let emptyView = ProjectsEmptyView()
  let notificationsButton: UIButton = .create(numberOfLines: 1, horizontalAlignment: .center, verticalAlignment: .center, backgroundColor: .clear, backgroundImage: nil, image: UIImage(named: "icoNotifications"), title: "", titleColor: .clear, font: .medium(12))
  let profileButton: UIButton = .create(numberOfLines: 1, horizontalAlignment: .center, verticalAlignment: .center, backgroundColor: .clear, backgroundImage: nil, image: UIImage(named: "icoProfile"), title: "", titleColor: .clear, font: .medium(12))
  
  private(set) lazy var flowLayout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    let width = floor((UIScreen.main.bounds.width - 71) / 2)
    layout.itemSize = CGSize(width: width, height: width)
    layout.scrollDirection = .vertical
    layout.minimumInteritemSpacing = 23
    layout.minimumLineSpacing = 23
    layout.sectionInset = UIEdgeInsets(top: 24, left: 24, bottom: 32, right: 24)
    return layout
  }()
  
  private(set) var refreshControl = UIRefreshControl()
  
  private(set) lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    collectionView.backgroundColor = .clear
    collectionView.alwaysBounceVertical = true
    collectionView.register(cellType: ProjectCell.self)
    collectionView.register(supplementaryViewType: ProjectsHeaderView.self, ofKind: ProjectsHeaderView.reuseIdentifier)
    collectionView.register(supplementaryViewType: ProjectsArchivedHeaderView.self, ofKind: ProjectsArchivedHeaderView.reuseIdentifier)
    collectionView.register(ProjectCell.self, forCellWithReuseIdentifier: "ProjectCell")
    collectionView.refreshControl = refreshControl
    collectionView.contentInset = .init(top: 20, left: 0, bottom: 20, right: 0)
    return collectionView
  }()
  
  // MARK: - Initialization
  init() {
    super.init(frame: .zero)
    
    [collectionView].forEach(addSubview(_:))
    collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ProjectsView {
  func onNotification() -> ControlEvent<Void> {
    return notificationsButton.rx.tap
  }
  
  func onProfile() -> ControlEvent<Void> {
    return profileButton.rx.tap
  }
}
