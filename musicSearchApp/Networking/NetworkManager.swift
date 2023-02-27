//
//  NetworkManager.swift
//  musicSearchApp
//
//  Created by KimChoonSik on 2023/02/27.
//

import Foundation

enum NetworkError: Error {
    case one
    case two
    case three
}



//MARK: - 네트워킹 클래스 모델

final class Networkmanager {
    
    // 여러 화면(여러 객체)에서 네트워크 통신이 필요한 경우가 많기 때문에 주로 싱글톤 패턴으로 생성함
    // 접근이 용이하도록 타입 프로퍼티, Naming은 shared를 주로 사용
    static let shared = Networkmanager()
    //싱글톤 패턴 구현을 위한 생성자 - let a = NetworkManager() 같은 객체 생성 방지
    private init() {}
    
    //네트워킹 요청하는 함수 (음악 데이터 가져오기)
    //네트워킹의 경우 비동기처리를 하기 때문에, 리턴값이 있는 형태로 함수를 설계하면 안됨 -> 콜백함수 활용해야함
//    func fetchMusic(searchTerm: String, completion: @escaping (Result<[Music], NetworkError>) -> Void {
//        let url = "
//        
//    }
    
}



