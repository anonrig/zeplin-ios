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
import ios_toolkit
import Kingfisher

final class ProjectViewController: UIViewController, ios_toolkit.View, ErrorDisplayer, LoadingHandler {
    // MARK: - Properties
    private lazy var viewSource = ProjectView()
    
    private(set) var bag: DisposeBag
    private(set) var viewModel: ProjectViewModel
    private(set) var loadingView: LoadingView
    
    // MARK: - Initialization
    init(with project: Project) {
        bag = DisposeBag()
        viewModel = ProjectViewModel(with: project)
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
        
        configureNavBar(with: viewModel.project.value.name ?? "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: viewSource.editModeButton)
        viewSource.editModeButton.snp.makeConstraints { $0.width.equalTo(70) }
    }
}

// MARK: - Observe Datasource
extension ProjectViewController: ProjectNavigator {
    private func observeDatasource() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<ScreenSection>(
          configureCell: { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScreenCell", for: indexPath) as! ScreenCell
            cell.populate(with: item, editMode: self.viewModel.editModeEnabled.value)
            cell.isSelected = self.viewModel.selectedScreens.value.contains(item)
            return cell
        }, configureSupplementaryView: { datasource, collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: "ScreenSectionHeaderView", withClass: ScreenSectionHeaderView.self, for: indexPath)
            let model = self.viewModel.sections.value[indexPath.section]
            header.populate(with: model.name!)
            
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
            .asDriver()
            .drive(onNext: { _ in
                self.viewModel.getScreens(isRefresh: true)
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
                self.viewSource.projectEditBar.isHidden = !enabled
            })
            .disposed(by: viewModel.bag)
        
        viewSource.editModeButton.rx.tap
            .asObservable()
            .map { _ in !self.viewModel.editModeEnabled.value}
            .bind(to: viewModel.editModeEnabled)
            .disposed(by: viewModel.bag)
        
        viewSource.collectionView.rx.itemSelected
            .asDriver()
            .drive(onNext: { indexPath in
                if self.viewModel.editModeEnabled.value {
                    let screens = self.viewModel.selectedScreens.value
                    let screen = self.viewModel.sections.value[indexPath.section].items[indexPath.row]
                    self.viewModel.selectedScreens.accept(screens +  [screen])
                } else {
                    let screen = self.viewModel.sections.value[indexPath.section].items[indexPath.row]
                    self.showScreen(screen)
                    self.viewSource.collectionView.reloadData()
                }
            })
            .disposed(by: viewSource.bag)
        
        viewSource.collectionView.rx
            .modelDeselected(Screen.self)
            .subscribe(onNext: { screen in
                if self.viewModel.editModeEnabled.value {
                    var screens = self.viewModel.selectedScreens.value
                    screens.removeAll(screen)
                    self.viewModel.selectedScreens.accept(screens)
                }
            })
            .disposed(by: viewSource.bag)
    
        viewModel.selectedScreens
            .asObservable()
            .map { $0.count }
            .subscribe(onNext: { count in
                let title = count > 0 ? "\(count) Screens Selected".localized() : "Select Screens".localized()
                self.viewSource.projectEditBar.titleLabel.text = title
                self.viewSource.projectEditBar.deleteButton.isEnabled = count > 0
            })
            .disposed(by: viewModel.bag)
        
        viewSource.projectEditBar.deleteButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                self.showAlert(title: "Oh, Snap!".localized(), message: "Zeplin API does not allow deleting screens, yet. Don’t worry, we let them know about it. Hopefully coming soon!".localized())
            })
            .disposed(by: viewSource.bag)
    }
}

extension ProjectViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.width, height: section == 0 ? 68 : 80)
    }
}
