import RxSwift
import RxCocoa
import ios_toolkit

final class ProjectsViewModel: ViewModel, RemoteLoading, ErrorHandler {
    // MARK: - Properties
    var bag: DisposeBag
    private(set) var isLoading = BehaviorRelay<Bool>(value: true)
    private(set) var onError = BehaviorRelay<ErrorObject?>(value: nil)
    private(set) var projects = BehaviorRelay<[Project]>(value: [])
    private(set) var sections = BehaviorRelay<[ProjectsSection]>(value: [])
    init() {
        bag = DisposeBag()
        
        getProjects()
    }
}

// MARK: - Fetch resource
extension ProjectsViewModel {
    private func getProjects() {
        Observable.just(())
            .map { _ in self.isLoading.accept(true) }
            .flatMap(NetworkProvider.shared.getProjects)
            .do(onNext: { _ in self.isLoading.accept(false) })
            .catchError({ error -> Observable<[Project]> in
                self.onError.accept(self.handleError(error: error))
                self.isLoading.accept(false)
                return .just([])
            })
            .filter { $0.count > 0 }
            .subscribe(onNext: { projects in
                self.projects.accept(projects)
                self.sections.accept([
                    ProjectsSection(header: "Projects".localized(), projects: projects.filter { $0.status != ProjectStatus.archived}),
                    ProjectsSection(header: "Archived Projects".localized(), projects: projects.filter { $0.status == ProjectStatus.archived})
                ])
            })
            .disposed(by: bag)
    }
}
