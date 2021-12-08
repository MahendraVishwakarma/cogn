//


import Foundation
import RxSwift
import Action

enum LoadingState: Int {
    case notLoad
    case loading
    case finished
    case failed
}

protocol BaseViewModelInput {

}

protocol BaseViewModelOuput {
    var baseStateObservable: Observable<LoadingState> { get }
    var baseErrorModelObservable: Observable<StoredPost?> { get }
}

protocol BaseViewModelType {
    var baseInputs: BaseViewModelInput { get }
    var baseOutputs: BaseViewModelOuput { get }
}

class BaseViewModel: NSObject, BaseViewModelInput, BaseViewModelOuput, BaseViewModelType {
    var disposeBag = DisposeBag()

    // MARK: Inputs & Outputs
    var baseInputs: BaseViewModelInput { return self }
    var baseOutputs: BaseViewModelOuput { return self }
    
    // MARK: Input

    // MARK: Output
    let baseStateObservable: Observable<LoadingState>
    let baseErrorModelObservable: Observable<StoredPost?>

    // MARK: Private
    let baseStateProperty = BehaviorSubject<LoadingState>(value: .notLoad)
    let baseErrorModelProperty = BehaviorSubject<StoredPost?>(value: nil)

    // MARK: Init
    override init() {
        baseStateObservable = baseStateProperty.asObservable()
        baseErrorModelObservable = baseErrorModelProperty.asObservable()
        super.init()
    }
   
    deinit {
       
    }
}
