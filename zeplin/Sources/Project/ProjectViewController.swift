//
//  ProjectViewController.swift
//  zeplin
//
//  Created by yagiz on 2/29/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Toolkit
import ToolkitRxSwift
import Kingfisher

final class ProjectViewController: UIViewController, ViewModelBased, LoadableController {
  var LoadingViewType: LoadableView.Type = LoadingView.self
  
  // MARK: - Properties
  var viewModel: ProjectViewModel!
  let viewSource = ProjectView()
  let bag = DisposeBag()
  
  // MARK: - Life cycle
  override func loadView() {
    view = viewSource
    view.backgroundColor = Colors.windowBackgroundBlack.color
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureNavBar(with: viewModel.project.name ?? "", prefersLargeTitle: false)
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: viewSource.editModeButton)
    
    observeDatasource()
    getScreens()
  }
}

// MARK: - Observe Datasource
extension ProjectViewController {
  private func getScreens() {
    Observable.just(())
      .do { self.rx.showLoading.onNext(true) }
      .flatMap(viewModel.getScreens)
      .do(onNext: { _ in self.rx.showLoading.onNext(false) })
      .catchError({ (error) -> Observable<[ScreenSection]> in
        self.rx.showAlert.onNext(.init(message: "An error has occurred, please try again later.".localized()))
        return .just([])
      })
      .bind(to: viewModel.sections)
      .disposed(by: viewModel.bag)
  }
  
  private func observeDatasource() {
    let dataSource = RxCollectionViewSectionedReloadDataSource<ScreenSection>(
      configureCell: { dataSource, collectionView, indexPath, item in
        let cell: ScreenCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.populate(with: item, editMode: self.viewModel.editModeEnabled.value)
        cell.isSelected = self.viewModel.selectedScreens.value.contains(item)
        return cell
    }, configureSupplementaryView: { datasource, collectionView, kind, indexPath in
      let header: ScreenSectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
      let model = self.viewModel.sections.value[indexPath.section]
      header.populate(with: model.name)
      
      header.isCollapsed.accept(model.isCollapsed)
      
      header.collapseButton.rx.tap
        .asDriver()
        .drive(onNext: { _ in
          var newSection = model
          newSection.isCollapsed.toggle()
          var sections = self.viewModel.sections.value
          sections[indexPath.section] = newSection
          self.viewModel.sections.accept(sections)
        })
        .disposed(by: header.bag)
      
      return header
    })
    
    viewModel.sections
      .asObservable()
      .bind(to: viewSource.collectionView.rx.items(dataSource: dataSource))
      .disposed(by: viewModel.bag)
    
    viewSource.collectionView.rx.setDelegate(self)
      .disposed(by: bag)
    
    viewSource.refreshControl.rx.controlEvent(.valueChanged)
      .asObservable()
      .flatMap(viewModel.getScreens)
      .do(onNext: { _ in self.viewSource.refreshControl.endRefreshing() })
      .catchError({ (error) -> Observable<[ScreenSection]> in
        self.rx.showAlert.onNext(.init(message: "An error has occurred, please try again later.".localized()))
        return .just([])
      })
      .bind(to: viewModel.sections)
      .disposed(by: viewSource.bag)
    
    viewModel.editModeEnabled
      .asDriver()
      .drive(onNext: { enabled in
        if (!enabled) {
          self.viewModel.selectedScreens.accept([])
          self.viewSource.collectionView.reloadData()
        }
        self.viewSource.collectionView.allowsMultipleSelection = enabled
        self.viewSource.editModeButton.setTitle(enabled ? "Cancel".localized() : "Select".localized(), for: .normal)
        self.viewSource.editModeButton.invalidateIntrinsicContentSize()
        self.viewSource.setProjectEditBarHidden(!enabled)
      })
      .disposed(by: viewModel.bag)
    
    viewSource.editModeButton.rx.tap
      .asObservable()
      .map { _ in !self.viewModel.editModeEnabled.value}
      .bind(to: viewModel.editModeEnabled)
      .disposed(by: viewModel.bag)
    
    viewSource.collectionView.rx.itemSelected
      .asDriver()
      .map { self.viewModel.sections.value.at(index: $0.section)?.items.at(index: $0.row)}
      .filter { $0 != nil }
      .map { $0! }
      .drive(onNext: { screen in
        if self.viewModel.editModeEnabled.value {
          let screens = self.viewModel.selectedScreens.value
          self.viewModel.selectedScreens.accept(screens +  [screen])
        } else {
          self.viewModel.screenRequired(screen: screen)
          self.viewSource.collectionView.reloadData()
        }
      })
      .disposed(by: viewSource.bag)
    
    viewSource.collectionView.rx
      .modelDeselected(Screen.self)
      .subscribe(onNext: { screen in
        if self.viewModel.editModeEnabled.value {
          var screens = self.viewModel.selectedScreens.value
          screens.removeAll(where: { $0.id == screen.id })
          self.viewModel.selectedScreens.accept(screens)
        }
      })
      .disposed(by: viewSource.bag)
    
    viewModel.selectedScreens
      .asObservable()
      .map { $0.count }
      .subscribe(onNext: { count in
        let title = count > 0 ? "\(count) Screens Selected".localized() : "Select Screens".localized()
        
        self.viewSource.setProjectEditBarState(title: title, enabled: count > 0)
      })
      .disposed(by: viewModel.bag)
    
    viewSource.onProjectDelete()
      .asDriver()
      .drive(onNext: { _ in
        //        self.showAlert(title: "Oh, Snap!".localized(), message: "Zeplin API does not allow deleting screens, yet. Don’t worry, we let them know about it. Hopefully coming soon!".localized())
      })
      .disposed(by: viewSource.bag)
  }
}

extension ProjectViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: view.width, height: section == 0 ? 68 : 80)
  }
}
