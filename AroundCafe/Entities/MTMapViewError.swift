
import Foundation

enum MTMapViewError: Error {
    case failedUpdatingCurrentLocation
    case locationAuthorizaationDenied
    
    var errorDescription: String{
        switch self{
        case .failedUpdatingCurrentLocation:
            return " 현재 위치를 불러오지 못했습니다."
            
        case .locationAuthorizaationDenied:
            return "위치 정보를 비활성화하면 사용자의 현재 위치를 알 수 없습니다."
        }
    }
}
