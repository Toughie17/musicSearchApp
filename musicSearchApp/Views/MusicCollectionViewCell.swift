//
//  MusicCollectionViewCell.swift
//  musicSearchApp
//
//  Created by KimChoonSik on 2023/02/28.
//

import UIKit

final class MusicCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var mainImageView: UIImageView!
    
    var imageUrl: String? {
        didSet {
            loadImage()
        }
    }
    
    private func loadImage() {
        guard let urlString = self.imageUrl, let url = URL(string: urlString)  else { return }
        
        DispatchQueue.global().async {
            //아래는 동기적으로 처리되는 코드임 그래서 DispatchQueue.global().async를 통해 다른 스레드로 넘김
            guard let data = try? Data(contentsOf: url) else { return }
            // 오래걸리는 작업이 일어나고 있는 동안에 url이 바뀔 가능성 제거 ⭐️⭐️⭐️
            guard urlString == url.absoluteString else { return }
            //뷰를 그리는 행위이기에 메인스레드에서 실행시켜야함.
            DispatchQueue.main.async {
                self.mainImageView.image = UIImage(data: data)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.mainImageView.image = nil
    }
}
