//
//  MusicCell.swift
//  musicSearchApp
//
//  Created by KimChoonSik on 2023/02/28.
//

import UIKit

class MusicCell: UITableViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    // image Url을 전달받는 속성
    // (셀에서 직접 로드하도록 -> 그래야 이미지 언매칭, 버벅이는 현상 방지 할 수 있음
    // 속성 감시자 didset 활용
    // 변수의 값이 바뀔 때 didset블록이 자동으로 실행됨
    // url 스트링이 새로 할당 될 때마다 이미지를 불러오는 함수를 실행시키는 의도
    var imageUrl: String? {
        didSet {
            loadImage()
        }
    }
    //셀은 재사용 된다는 점을 기억해야함(메모리 효율성을 위해)
    //prepareForReuse는 셀이 재사용 되기 전에 호출되는 메서드
    override func prepareForReuse() {
        print(#function)
        super.prepareForReuse()
        // 이미지가 바뀌는 것처럼 보이는 현상을 없애기 위해서 실행하는 코드
        // 데이터를 새로 교체하기 전에 미리 비워주는 느낌.
        self.mainImageView = nil
    }
    // 스토리보드, Nib으로 만들 때 사용하는 생성자 코드
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //뷰의 크기에 맞게 콘텐츠의 비율을 변경하여 확장하는 옵션
        //Aspect는 콘텐츠의 비율이 유지됨.
        mainImageView.contentMode = .scaleToFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("셀이 선택되었습니다.")
        // Configure the view for the selected state
    }
    // 위 imageUrl변수를 통해 이미지를 세팅하는 메서드
    private func loadImage() {
        guard let urlString = self.imageUrl, let url = URL(string: urlString) else { return }
        //이미지를 로딩하고 세팅하는 작업은 오래 걸리기 때문에(동기) 비동기 처리를 해줌
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            //작업이 이루어지는 동안 url이 바뀔 가능성 제거 (ex.빠른 스크롤 시)
            //returns a String representation of the absolute URL of the instance.
            guard urlString == url.absoluteString else { return }
            //뷰를 그리는 행위 이기에 메인 스레드에서 동작하도록
            DispatchQueue.main.async {
                self.mainImageView.image = UIImage(data: data)
            }
        }
    }
}
