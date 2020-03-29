import RxSwift
import RxCocoa
import Toolkit
import UIKit

final class ProjectsViewModel: ViewModel, RemoteLoading, ErrorHandler {
    // MARK: - Properties
    var bag: DisposeBag
    private(set) var isLoading = BehaviorRelay<Bool>(value: true)
    private(set) var onError = BehaviorRelay<ErrorObject?>(value: nil)
    private(set) var projects = BehaviorRelay<[Project]>(value: [])
    private(set) var sections = BehaviorRelay<[ProjectsSection]>(value: [])
    private(set) var shownSections = BehaviorRelay<[ProjectsSection]>(value: [])
    private(set) var isRefreshing = BehaviorRelay<Bool>(value: false)
    private(set) var selectedScope = BehaviorRelay<ProjectStatus>(value: .all)
    private(set) var searchText = BehaviorRelay<String?>(value: nil)
    
    private(set) lazy var searchController: UISearchController = {
        let view = UISearchController(searchResultsController: nil)
        view.obscuresBackgroundDuringPresentation = false
        view.searchBar.placeholder = "Search Projects"
        view.searchBar.scopeButtonTitles = ["All".localized(), "Active".localized(), "Archived".localized()]
        return view
    }()
    
    init() {
        bag = DisposeBag()
        
        getProjects()
        observeDatasources()
    }
}

// MARK: - Fetch resource
extension ProjectsViewModel {
    func getProjects(isRefresh: Bool = false) {
        let loadingHandler = isRefresh ? isRefreshing : isLoading
        Observable.just(())
            .map { _ in loadingHandler.accept(true) }
            .flatMap(NetworkProvider.shared.getProjects)
            .do(onNext: { _ in loadingHandler.accept(false) })
            .catchError({ error -> Observable<[Project]> in
                self.onError.accept(self.handleError(error: error))
                loadingHandler.accept(false)
                return .just([])
            })
            .filter { $0.count > 0 }
            .subscribe(onNext: { projects in
                self.projects.accept(projects)
                let archivedProjects = projects.get(for: .archived)
                let archivedSection: [ProjectsSection] = archivedProjects.count == 0 ? [] : [
                    ProjectsSection(header: "Archived Projects".localized(), status: .archived, projects: archivedProjects)
                ]
                
                self.sections.accept([
                    ProjectsSection(header: "Projects".localized(), status: .active, projects: projects.get(for: .active))
                ] + archivedSection)
                self.shownSections.accept(self.sections.value)
            })
            .disposed(by: bag)
    }
}

// MARK: - Observe datasources
extension ProjectsViewModel {
    func observeDatasources() {
        selectedScope
            .asDriver()
            .drive(onNext: { scope in
                switch scope {
                case .all:
                    self.shownSections.accept(self.sections.value)
                case .active:
                    self.shownSections.accept(self.sections.value.filter { $0.status == .active })
                case .archived:
                    self.shownSections.accept(self.sections.value.filter { $0.status == .archived })
                }
            })
            .disposed(by: bag)
        
        searchController.searchBar.rx.selectedScopeButtonIndex
            .asDriver()
            .drive(onNext: { index in
                switch index {
                case 0:
                    self.selectedScope.accept(.all)
                case 1:
                    self.selectedScope.accept(.active)
                case 2:
                    self.selectedScope.accept(.archived)
                default:
                    print("invalid scope")
                }
            }).disposed(by: bag)
        
        selectedScope
            .asDriver()
            .drive(onNext: { scope in
                let searchTerm = self.searchText.value
                var activeSectionScope = scope == .all ? self.sections.value : self.sections.value.filter { $0.status == scope }
                
                if let text = searchTerm, text.count > 0 {
                    activeSectionScope = activeSectionScope.map { section -> ProjectsSection in
                        let items = section.projects.filter { ($0.name?.lowercased().contains(text.lowercased()) ?? false) }
                        return ProjectsSection(original: section, items: items)
                    }.filter { $0.projects.count > 0 }
                }
                self.shownSections.accept(activeSectionScope)
            })
            .disposed(by: bag)

        searchController.searchBar.rx.text
            .asObservable()
            .bind(to: searchText)
            .disposed(by: bag)
        
        searchController.searchBar.rx.cancelButtonClicked
            .asDriver()
            .drive(onNext: { _ in
                self.selectedScope.accept(.all)
                self.searchText.accept(nil)
            })
            .disposed(by: bag)
            
        searchText
            .asObservable()
            .subscribe(onNext: { text in
                let existingSections = self.sections.value

                if let text = text, text.count != 0 {
                    let scope = self.selectedScope.value
                    let activeSectionScope = scope == .all ? self.shownSections.value : self.shownSections.value.filter { $0.status == scope }
                    let filteredSections = activeSectionScope.map { section -> ProjectsSection in
                        let items = section.projects.filter { ($0.name?.lowercased().contains(text.lowercased()) ?? false) }
                        return ProjectsSection(original: section, items: items)
                    }.filter { $0.projects.count > 0 }
                    self.shownSections.accept(filteredSections)
                } else {
                    self.shownSections.accept(existingSections)
                }
                
            })
            .disposed(by: bag)
    }
}
