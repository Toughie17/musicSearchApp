//
//  ViewController.swift
//  musicSearchApp
//
//  Created by KimChoonSik on 2023/02/27.
//

import UIKit

class ViewController: UIViewController {

    
    //테이블뷰 연결, -> 테이블에 올릴 셀 생성 필요
    @IBOutlet weak var musicTableView: UITableView!
    //네트워크 매니저
    var networkManager = Networkmanager.shared
    // 음악 데이터
    var musicArrays: [Music] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupData()
        // Do any additional setup after loading the view.
    }
    
    func setupTableView() {
        musicTableView.dataSource = self
        // tableView cellForRowAt 메서드에서 디큐를 하기 위해서는 먼저 셀을 등록하는 과정이 필요함
        musicTableView.register(UINib(nibName: Cell.musicCellIdentifier, bundle: nil), forCellReuseIdentifier: Cell.musicCellIdentifier)
    }
    
    
    //데이터 셋업
    func setupData() {
        
        networkManager.fetchMusic(searchTerm: "pop") { result in
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
    
    func tableView(_ talbeView: UITableView heightForRowAt: indexPath: IndexPath) -> CGFloat {
        return 120
    }
    // 자동으로 높이가 조절되는 코드도 있음.
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return UITableView.automaticDimension
    //    }
}

