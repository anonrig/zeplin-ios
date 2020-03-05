import SnapKit
import UIKit
import RxSwift

final class ProjectsView: UIView {
    // MARK: - Properties
    var bag = DisposeBag()
    
    private(set) var emptyView = ProjectsEmptyView()
    
    private(set) var notificationsButton: UIButton = .create(numberOfLines: 1, horizontalAlignment: .center, verticalAlignment: .center, backgroundColor: .clear, backgroundImage: nil, image: UIImage(named: "icoNotifications"), title: "", titleColor: .clear, font: .medium(12))
    
    private(set) var profileButton: UIButton = .create(numberOfLines: 1, horizontalAlignment: .center, verticalAlignment: .center, backgroundColor: .clear, backgroundImage: nil, image: UIImage(named: "icoProfile"), title: "", titleColor: .clear, font: .medium(12))
    
    private(set) lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width - 71) / 2
        layout.itemSize = CGSize(width: width, height: width)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 23
        layout.minimumLineSpacing = 23
        layout.sectionInset = .zero
        layout.invalidateLayout()
        return layout
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 24, right: 24)
        collectionView.register(ProjectCell.self, forCellWithReuseIdentifier: "ProjectCell")
        collectionView.register(supplementaryViewOfKind: "ProjectsHeaderView", withClass: ProjectsHeaderView.self)
        collectionView.register(supplementaryViewOfKind: "ProjectsArchivedHeaderView", withClass: ProjectsArchivedHeaderView.self)
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
