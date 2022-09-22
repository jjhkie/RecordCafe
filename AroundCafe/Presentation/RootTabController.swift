
import UIKit
import RxSwift

class RootTabController: UITabBarController{
    
    let MapVM = LocationInformationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO 아이콘 이미지 변경하기
        
        let recordViewController = UINavigationController(rootViewController: RecordInformationViewController())
        recordViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        
        
        let mapViewController = UINavigationController(rootViewController: LocationInformationViewController())
        mapViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
                
        viewControllers = [recordViewController, mapViewController]
    }
    
}
