
import Foundation
import SnapKit
import RxSwift


class RecordInformationViewController : UIViewController{
    
    let disposeBag = DisposeBag()
    
    let tableView = UITableView()
    let addButton = UIBarButtonItem()

    private lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        
        return imagePicker
    }()
    
    let VM = RecordInformationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind(VM)
        attribute()
        layout()
    }
   
    private func bind(_ VM: RecordInformationViewModel){
        
    }

    private func attribute(){
        view.backgroundColor = .white
        
        addButton.image = UIImage(systemName: "location.fill")
        addButton.target = self
        addButton.action = #selector(didTapUploadButton)
        
        navigationItem.setRightBarButton(addButton, animated: true)
    }
    
    ///image select 화면 이동
    @objc func didTapUploadButton(){
        present(imagePicker, animated: true)
    }
    
    private func layout(){
        [tableView].forEach{
            view.addSubview($0)
        }
        tableView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
