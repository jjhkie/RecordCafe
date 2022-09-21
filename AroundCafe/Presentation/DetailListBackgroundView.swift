
import RxSwift
import RxCocoa

class DetailListBackgroundView: UIView{
    let disposeBag = DisposeBag()
    
    let statusLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ VM: DetailListBackgroundViewModel){
        VM.isStatusLabelHidden
            .emit(to: statusLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
    }
    
    private func attribute(){
        backgroundColor = .white
        
        statusLabel.text = "🏚"
        statusLabel.textAlignment = .center
        
    }
    
    private func layout(){
        addSubview(statusLabel)
        
        statusLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
