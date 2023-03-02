//
//  ViewController.swift
//  musicSearchApp
//
//  Created by KimChoonSik on 2023/02/27.
//

import UIKit

final class ViewController: UIViewController {

    
    //테이블뷰 연결, -> 테이블에 올릴 셀 생성 필요
    @IBOutlet weak var musicTableView: UITableView!
    //네트워크 매니저
    let networkManager = Networkmanager.shared
    // 음악 데이터
    var musicArrays: [Music] = []
    
    let searchController = UISearchController(searchResultsController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
        setupData()
    }

    private func setupTableView() {
        musicTableView.dataSource = self
        musicTableView.delegate = self
        // tableView cellForRowAt 메서드에서 디큐를 하기 위해서는 먼저 셀을 등록하는 과정이 필요함
        musicTableView.register(UINib(nibName: Cell.musicCellIdentifier, bundle: nil), forCellReuseIdentifier: Cell.musicCellIdentifier)
    }
    
    
    //데이터 셋업
    private func setupData() {
        networkManager.fetchMusic(searchTerm: "jazz") { result in
            switch result {
            case .success(let musicData):
                //데이터 배열을 받아옴
                self.musicArrays = musicData
                // 테이블 뷰를 리로드 해줘야함(새로운 데이터를 활용해)
                // 뷰를 그리는 행동이기 때문에 메인 스레드에서 실행 해줘야함
                DispatchQueue.main.async {
                    self.musicTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupSearchBar() {
        self.title = "Music Search"
        navigationItem.searchController = searchController
        
        //단순한 서치바를 사용한다면
        //searchController.searchBar.delegate = self
        
        //서치 결과 컨트롤러 사용(복잡한 구현 가능)
        //ex. 글자마다 검색 + 새로운 화면 보여주기 기능 등
        searchController.searchResultsUpdater = self
        //첫글자 대문자 방지
        searchController.searchBar.autocapitalizationType = .none
    }
}

extension ViewController: UITableViewDataSource {
    //테이블 뷰에 몇개의 로우가 필요한지(섹션 안에)_ 지금은 따로 섹션을 나누지 않았음
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.musicArrays.count
    }
    
    //called by the table view's data source to get a cell that will be displayed at a specific index path of the table view.
    
    // indexPath: An instance of IndexPath that represents the location of the cell in the table view. 테이블 뷰에서 셀의 위치 (섹션, 로우)
    // The indexPath parameter contains both the section and row index for the cell.
    
    //테이블뷰 셀은 힙 메모리에 저장되어 있고, 이들은 재사용됨
    // 이미지를 직접 테이블뷰 세팅 메서드에서 할당하는 설계는 빠르게 스크롤 할 때 이미지가 잘못 표기되는 부작용을 야기할 수 있음.
    // 따라서 String값을 받아 셀에서 로딩하는 방식으로 설계함.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //등록해둔 셀을 dequeue방식으로 사용, 해당 셀의 타입으로 타입캐스팅도 해줘야힘
        let cell = musicTableView.dequeueReusableCell(withIdentifier: Cell.musicCellIdentifier, for: indexPath) as! MusicCell
        
        //cell의 imageUrl 변수에 String 값을 넘겨주면 didSet을 통해 loadImage 메서드가 실행됨. -> 셀에서 이미지 로드
        cell.imageUrl = musicArrays[indexPath.row].imageUrl
        
        cell.songNameLabel.text = musicArrays[indexPath.row].songName
        cell.artistNameLabel.text = musicArrays[indexPath.row].artistName
        cell.albumNameLabel.text = musicArrays[indexPath.row].albumName
        cell.releaseDateLabel.text = musicArrays[indexPath.row].releaseDateString
        
        cell.selectionStyle = .none
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    //테이블 뷰의 높이를 유동적으로 조절할 수 있는 메서드
    // setupTableView() 메서드에서 musicTableView.rowHeight = 120 등으로 조절도 가능
    
    func tableView(_ talbeView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    // 자동으로 높이가 조절되는 코드도 있음.
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return UITableView.automaticDimension
    //    }
}

// 검색하는 동안 새로운 화면이 즉시 뜨는 서치바 구현

extension ViewController: UISearchResultsUpdating {
    //유저가 글자를 입력할 때마다 호출되는 메서드 -> 일반적으로 즉시 화면이 바뀌는 경우 사용
    func updateSearchResults(for searchController: UISearchController) {
        //글자를 치는 순간마다 다른 컬렉션 뷰를 보여주는 코드
        let vc = searchController.searchResultsController as! SearchResultViewController
        vc.searchTerm = searchController.searchBar.text ?? ""
    }
}









// 🍏 단순한 서치바 확장
//extension ViewController: UISearchBarDelegate {
//
//    // 유저가 글자를 입력하는 순간마다 호출되는 메서드
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        print(searchText)
//        // 다시 빈 배열로 만들기 ⭐️
//        self.musicArrays = []
//
//        // 네트워킹 시작
//        networkManager.fetchMusic(searchTerm: searchText) { result in
//            switch result {
//            case .success(let musicDatas):
//                self.musicArrays = musicDatas
//                DispatchQueue.main.async {
//                    self.musicTableView.reloadData()
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//}
//
//    // 검색(Search) 버튼을 눌렀을때 호출되는 메서드
////    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
////        guard let text = searchController.searchBar.text else {
////            return
////        }
////        print(text)
////        // 다시 빈 배열로 만들기 ⭐️
////        self.musicArrays = []
////
////        // 네트워킹 시작
////        networkManager.fetchMusic(searchTerm: text) { result in
////            switch result {
////            case .success(let musicDatas):
////                self.musicArrays = musicDatas
////                DispatchQueue.main.async {
////                    self.musicTableView.reloadData()
////                }
////            case .failure(let error):
////                print(error.localizedDescription)
////            }
////        }
////        self.view.endEditing(true)
////    }
//}
