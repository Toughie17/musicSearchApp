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
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    


}

