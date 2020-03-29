import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Toolkit
import OneSignal

final class ProjectsViewController: UIViewController, View, ErrorDisplayer, LoadingHandler {
    // MARK: - Properties
    private lazy var viewSource = ProjectsView()
    
    private(set) var bag: DisposeBag
    private(set) var viewModel: ProjectsViewModel
    private(set) var loadingView: LoadingView
    private(set) var logoutObservable = PublishSubject<Void>()
    
    // MARK: - Initialization
    init() {
        bag = DisposeBag()
        viewModel = ProjectsViewModel()
        loadingView = LoadingView()
        
        super.init(nibName: nil, bundle: nil)
        
        bindLoading()
        bindErrorHandling()
        observeDatasource()
    }
    
    // MARK: - Life cycle
    override func loadView() {
        view = viewSource
        view.backgroundColor = Colors.windowBackgroundBlack.color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = UIImageView(image: UIImage(named: "logoZeplin"))
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: viewSource.notificationsButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: viewSource.profileButton)
        
        definesPresentationContext = true
        navigationItem.searchController = viewModel.searchController
        
        OneSignal.promptForPushNotifications(userResponse: { _ in })
    }
}

// MARK: - Observe Datasource
extension ProjectsViewController: ProjectsNavigator {
    private func observeDatasource() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<ProjectsSection>(
          configureCell: { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectCell", for: indexPath) as! ProjectCell
            cell.populate(with: item, isArchived: indexPath.section == 1)
            return cell
        }, configureSupplementaryView: { datasource, collectionView, kind, indexPath in
            if indexPath.section == 0 {
                 return collectionView.dequeueReusableSupplementaryView(ofKind: "ProjectsHeaderView", withClass: ProjectsHeaderView.self, for: indexPath)
            }
           
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: "ProjectsArchivedHeaderView", withClass: ProjectsArchivedHeaderView.self, for: indexPath)
            
            let project = self.viewModel.sections.value[indexPath.section]

            header.isCollapsed.accept(project.isCollapsed)

            header.collapseButton.rx.tap
                .asDriver()
                .drive(onNext: { collapsed in
                    var section = self.viewModel.sections.value[1]
                    section.isCollapsed.toggle()
                    self.viewModel.sections.accept([self.viewModel.sections.value[0]] + [section])
                })
                .disposed(by: header.bag)

            return header
        })

        viewSource.collectionView.rx.setDelegate(self)
            .disposed(by: bag)
        
        viewSource.refreshControl.rx.controlEvent(.valueChanged)
            .asDriver()
            .drive(onNext: { _ in
                self.viewModel.getProjects(isRefresh: true)
            })
            .disposed(by: viewSource.bag)
        
        viewModel.isRefreshing
            .asDriver()
            .drive(onNext: { isRefreshing in
                let control = self.viewSource.refreshControl
                if isRefreshing {
                    control.beginRefreshing()
                } else {
                    control.endRefreshing()
                }
            })
            .disposed(by: viewModel.bag)
        
        viewModel.shownSections
            .asDriver()
            .map { $0.count > 0 ? nil : self.viewSource.emptyView }
            .drive(onNext: {
                self.viewSource.collectionView.backgroundView = $0
            })
            .disposed(by: viewModel.bag)

        viewModel.shownSections
            .asObservable()
            .bind(to: viewSource.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: viewModel.bag)
        
        viewSource.collectionView.rx.itemSelected
            .subscribe(onNext: {
                self.showProject(self.viewModel.sections.value[$0.section].items[$0.row])
            })
            .disposed(by: viewSource.bag)
        
        viewSource.profileButton.rx.tap
            .map { _ in }
            .subscribe(onNext: self.showProfile)
            .disposed(by: viewSource.bag)
        
        viewSource.notificationsButton.rx.tap
            .map { _ in }
            .subscribe(onNext: self.showNotifications)
            .disposed(by: viewSource.bag)
    }
}

extension ProjectsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.width, height: section == 0 ? 93 : 127)
    }
}
