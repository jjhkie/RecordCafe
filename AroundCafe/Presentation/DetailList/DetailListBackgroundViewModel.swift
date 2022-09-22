
import RxSwift
import RxCocoa

struct DetailListBackgroundViewModel {
    
    let isStatusLabelHidden: Signal<Bool>
    
    let shouldHideStatusLabel = PublishSubject<Bool>()
    
    init(){
        isStatusLabelHidden = shouldHideStatusLabel
            .asSignal(onErrorJustReturn: true)
    }
}
