//
//  MusicCollectionViewController.swift
//  musicSearchApp
//
//  Created by KimChoonSik on 2023/02/28.
//

import UIKit

class SearchResultViewController: UIViewController {
    //컬렉션뷰 연결 ->스토리보드 상에서도 Class 연결 해주기
    @IBOutlet weak var collectionView: UICollectionView!
    
    //컬렉션뷰의 레이아웃을 담당하는 객체
    let flowLayout = UICollectionViewFlowLayout()
    
    let networkManager = Networkmanager.shared
    
    var musicArrays: [Music] = []
    
    //서치바에서 입력한 단어를 받아오는 변수
    var searchTerm: String? {
        didSet {
            setupData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        setupData()
    }
    
    //현재 테이블뷰에 item이 내장되어 있기 때문에 register 절차는 필요없음.
    func setupCollectionView() {
        //flowLayout 객체를 여기서 선언해줘도 됨
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        //컬렉션 뷰의 스크롤 방향 설정 ⭐️
        flowLayout.scrollDirection = .vertical
        
        //셀의 넓이 계산하기 위한 상수
        //스크린의 넓이(UIScreen.main.bounds.width)에서 분할하는 영역을 제거하고, 셀의 개수만큼 영역을 나눠주는 방식
        let collectionCellWidth = (UIScreen.main.bounds.width - (CVCell.spacingwidth * (CVCell.cellColumns - 1) )) / CVCell.cellColumns
        
        //아이템 사이즈 설정
        flowLayout.itemSize = CGSize(width: collectionCellWidth, height: collectionCellWidth)
        //아이템 사이 간격 설정
        flowLayout.minimumInteritemSpacing = CVCell.spacingwidth
        
        //컬렉션뷰의 속성에 할당
        collectionView.collectionViewLayout = flowLayout
    }
    
    
    func setupData() {
        guard let term = searchTerm else { return }
        
        self.musicArrays = []
        
        networkManager.fetchMusic(searchTerm: term) { result in
            switch result {
            case .success(let musicData):
                self.musicArrays = musicData
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case . failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicArrays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.musicCollectionViewCell, for: indexPath) as! MusicCollectionViewCell
        cell.imageUrl = musicArrays[indexPath.row].imageUrl
        return cell
    }
    
    
    
}
