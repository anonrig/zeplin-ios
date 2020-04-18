import RxSwift
import RxCocoa
import RxFlow
import Toolkit
import UIKit
import Moya

final class ProjectsViewModel: ServicesViewModel, Stepper {
  typealias Services = AppServices
  
  // MARK: - Properties
  var services: Services!
  let steps = PublishRelay<Step>()
  let bag = DisposeBag()
  
  let projects = BehaviorRelay<[Project]>(value: [])
  let sections = BehaviorRelay<[ProjectsSection]>(value: [])
  let shownSections = BehaviorRelay<[ProjectsSection]>(value: [])
  let selectedScope = BehaviorRelay<ProjectStatus>(value: .all)
  let searchText = BehaviorRelay<String?>(value: nil)
  let onErrorShouldLogin = PublishSubject<Void>()
  
  let searchController: UISearchController = {
    let view = UISearchController(searchResultsController: nil)
    view.obscuresBackgroundDuringPresentation = false
    view.searchBar.placeholder = "Search Projects".localized()
    view.searchBar.scopeButtonTitles = ["All".localized(), "Active".localized(), "Archived".localized()]
    return view
  }()
  
  init() {
    observeDatasources()
  }
  
  func notificationsRequired() {
    steps.accept(ProjectsSteps.notificationsRequired)
  }
  
  func profileRequired() {
    steps.accept(ProjectsSteps.profileRequired)
  }
  
  func projectRequired(_ project: Project) {
    steps.accept(ProjectsSteps.projectRequired(project: project))
  }
}

// MARK: - Fetch resource
extension ProjectsViewModel {
  func getProjects() -> Observable<Void> {
    return services.zeplinServices.getProjects()
      .map { projects in
        self.projects.accept(projects)
        let archivedProjects = projects.get(for: .archived)
        let archivedSection: [ProjectsSection] = archivedProjects.count == 0 ? [] : [
          ProjectsSection(header: "Archived Projects".localized(), status: .archived, projects: archivedProjects)
        ]
        
        self.sections.accept([
          ProjectsSection(header: "Projects".localized(), status: .active, projects: projects.get(for: .active))
          ] + archivedSection)
        self.shownSections.accept(self.sections.value)
      }
  }
}

// MARK: - Observe datasources
extension ProjectsViewModel {
  func observeDatasources() {
    onErrorShouldLogin
      .asObservable()
      .map { _ in ProjectsSteps.logoutRequired }
      .bind(to: steps)
      .disposed(by: bag)

    selectedScope
      .asObservable()
      .map {
        let sections = self.sections.value
        switch $0 {
          case .all: return sections
          case .active: return sections.filter { $0.status == .active }
          case .archived: return sections.filter { $0.status == .archived }
        }
      }
      .bind(to: shownSections)
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
          fatalError("Invalid scope")
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
      .map { text in
        let existingSections = self.sections.value
        
        if let text = text, text.count != 0 {
          let scope = self.selectedScope.value
          let activeSectionScope = scope == .all ? self.shownSections.value : self.shownSections.value.filter { $0.status == scope }
          return activeSectionScope.map { section -> ProjectsSection in
            let items = section.projects.filter { ($0.name?.lowercased().contains(text.lowercased()) ?? false) }
            return ProjectsSection(original: section, items: items)
          }.filter { $0.projects.count > 0 }
        }
        
        return existingSections
      }
      .bind(to: shownSections)
      .disposed(by: bag)
  }
}
