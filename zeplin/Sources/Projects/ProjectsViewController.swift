import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Toolkit
import ToolkitRxSwift
import OneSignal

final class ProjectsViewController: UIViewController, ViewModelBased, LoadableController {
  var LoadingViewType: LoadableView.Type = LoadingView.self
  
  // MARK: - Properties
  var viewModel: ProjectsViewModel!
  let viewSource = ProjectsView()
  let bag = DisposeBag()
  
  // MARK: - Life cycle
  override func loadView() {
    view = viewSource
    view.backgroundColor = Colors.windowBackgroundBlack.color
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.titleView = UIImageView(image: UIImage(named: "logoZeplin"))
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: viewSource.notificationsButton)
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: viewSource.profileButton)
    
    definesPresentationContext = true
    navigationItem.searchController = viewModel.searchController
    
    OneSignal.promptForPushNotifications(userResponse: { _ in })
    
    viewSource.collectionView.delegate = self
    observeDatasource()
    getProjects()
  }
}

// MARK: - Observe Datasource
extension ProjectsViewController {
  private func getProjects() {
    Observable.just(())
      .do { self.rx.showLoading.onNext(true) }
      .flatMap(viewModel.getProjects)
      .do(onNext: { _ in self.rx.showLoading.onNext(false) })
      .catchError({ (error) -> Observable<()> in
        self.rx.showAction.onNext(.init(image: UIImage(named: "error")!, title: "Shoot!".localized(), description: "Some error has occurred and you need to login again.".localized(), actionTitle: "LOGIN AGAIN".localized(), onAction: self.viewModel.onErrorShouldLogin))
        return .just(())
      })
      .subscribe()
      .disposed(by: viewModel.bag)
  }
  
  private func observeDatasource() {
    let dataSource = RxCollectionViewSectionedAnimatedDataSource<ProjectsSection>(
      configureCell: { dataSource, collectionView, indexPath, item in
        let cell: ProjectCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.populate(with: item, isArchived: indexPath.section == 1)
        return cell
    }, configureSupplementaryView: { datasource, collectionView, kind, indexPath in
      if indexPath.section == 0 {
        let header: ProjectsHeaderView = collectionView
          .dequeueReusableSupplementaryView(ofKind: ProjectsHeaderView.reuseIdentifier, for: indexPath)
        return header
      }
      
      let header: ProjectsArchivedHeaderView = collectionView
        .dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
      
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
    
    viewSource.refreshControl.rx.controlEvent(.valueChanged)
      .asObservable()
      .observeOn(MainScheduler.instance)
      .flatMap(viewModel.getProjects)
      .catchError({ (error) -> Observable<()> in
        self.rx.showAction.onNext(.init(image: UIImage(named: "error")!, title: "Shoot!".localized(), description: "Some error has occurred and you need to login again.".localized(), actionTitle: "LOGIN AGAIN".localized(), onAction: self.viewModel.onErrorShouldLogin))
        return .just(())
      })
      .subscribe(onNext: { _ in
        self.viewSource.refreshControl.endRefreshing()
      })
      .disposed(by: viewSource.bag)
    
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
      .asDriver()
      .map { self.viewModel.sections.value[$0.section].items[$0.row] }
      .drive(onNext: {
        self.viewModel.projectRequired($0)
      })
      .disposed(by: viewSource.bag)
    
    viewSource.onProfile()
      .asDriver()
      .drive(onNext: { _ in self.viewModel.profileRequired() })
      .disposed(by: viewSource.bag)
    
    viewSource.onNotification()
      .asDriver()
      .drive(onNext: { _ in self.viewModel.notificationsRequired() })
      .disposed(by: viewSource.bag)
  }
}

extension ProjectsViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    let height = section == 0 ? ProjectsHeaderView.defaultHeight : ProjectsArchivedHeaderView.defaultHeight
    return CGSize(width: collectionView.frame.width, height: height)
  }
}
