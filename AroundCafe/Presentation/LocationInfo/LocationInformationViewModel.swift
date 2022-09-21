

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
    
    private let documentData = PublishSubject<[KLDocument]>()
    
    init(model: LocationInformationModel = LocationInformationModel()){
        
        //네트워크 통신으로 데이터 불러오기
        let cvsLocationDataResult = mapCenterPoint
            .flatMapLatest(model.getLocation)
            .share()
        
        let cvsLocationDataValue = cvsLocationDataResult
            .compactMap{data -> LocationData? in
                guard case let .success(value) = data else {
                    return nil
                }
                return value
            }
        
        let cvsLocationDataErrorMessage = cvsLocationDataResult
            .compactMap{ data -> String? in
                switch data{
                case let .success(data) where data.documents.isEmpty:
                    return """
                        500m 근처에 이용할 수 없는 카페가 없습니다.
                        재검색해주세요
                        """
                case let .failure(error):
                    return error.localizedDescription
                default:
                    return nil
                }
            }
        
        cvsLocationDataValue
            .map{ $0.documents}
            .bind(to: documentData)
            .disposed(by: disposeBag)
        
        //지도 중심점 설정
        let selectDetailListItem = detailListItemSelected
            .withLatestFrom(documentData){ $1[$0]}
            .map{data -> MTMapPoint in
                guard let longtitue = Double(data.x),
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
        errorMessage = Observable
            .merge(
                cvsLocationDataErrorMessage,
                mapViewError.asObservable()
            )
            .asSignal(onErrorJustReturn: "잠시 후 다시 시도해주세요")
        
        detailListCellData = documentData
            .map(model.documentsToCellData)
            .asDriver(onErrorDriveWith: .empty())
        
        documentData
            .map{!$0.isEmpty}
            .bind(to: detailListBackgroundViewModel.shouldHideStatusLabel)
            .disposed(by: disposeBag)
        
        scrollToSelectedLocation = selectPOIItem
            .map{$0.tag}
            .asSignal(onErrorJustReturn: 0)
    }
}
