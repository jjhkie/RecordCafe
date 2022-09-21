

import RxSwift
import RxCocoa


struct LocationInformationViewModel{
    let disposeBag = DisposeBag()
    
    //sub ViewModels
    let detailListBackgroundViewModel = DetailListBackgroundViewModel()
    

    
    // viewModel -> view
    let setMapCenter: Signal<MTMapPoint> //센터를 잡아주는 이벤트
    let errorMessage: Signal<String> //에러 메세지를 전달해주는 이벤트
    let detailListCellData: Driver<[DetailListCellData]>
    let scrollToSelectedLocation: Signal<Int>
    
    //view -> ViewModel
    let currentLocation = PublishRelay<MTMapPoint>()
    let mapCenterPoint = PublishRelay<MTMapPoint>()
    let selectPOIItem = PublishRelay<MTMapPOIItem>()
    let mapViewError = PublishRelay<String>()
    let currentLocationButtonTapped = PublishRelay<Void>()
    let detailListItemSelected = PublishRelay<Int>()
    
    let documentData = PublishSubject<[KLDocument?]>()
    
    init(){
        //지도 중심점 설정
        let selectDetailListItem = detailListItemSelected
            .withLatestFrom(documentData){ $1[$0]}
            .map{data -> MTMapPoint in
                guard let data = data,
                      let longtitue = Double(data.x),
                      let latitude = Double(data.y) else { return MTMapPoint()}
                let geoCoord = MTMapPointGeo(latitude: latitude, longitude: longtitue)
                return MTMapPoint(geoCoord: geoCoord)
            }
        let moveToCurrentLocation = currentLocationButtonTapped
            .withLatestFrom(currentLocation)
        
        let currentMapCenter = Observable
            .merge(
                selectDetailListItem,
                currentLocation.take(1),//단 1개의 아이템만 내보내기 위해
                moveToCurrentLocation
            )
        
        setMapCenter = currentMapCenter
            .asSignal(onErrorSignalWith: .empty())
        
        //에러 메세지 전달
        errorMessage = mapViewError.asObservable()
            .asSignal(onErrorJustReturn: "잠시 후 다시 시도해주세요")
        
        detailListCellData = Driver.just([])
        
        scrollToSelectedLocation = selectPOIItem
            .map{$0.tag}
            .asSignal(onErrorJustReturn: 0)
    }
}
