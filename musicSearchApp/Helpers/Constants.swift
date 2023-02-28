//
//  Constants.swift
//  musicSearchApp
//
//  Created by KimChoonSik on 2023/02/27.
//

import Foundation
//MARK: - 매직 스트링 사용을 지양하기 위한 NameSpace
// 열거형 혹은 구조체로 선언 가능

//열거형은 case 자체가 데이터이기 때문에 저장속성을 만들 수 없음 -> 타입 저장속성은 생성 가능
public enum MusicApi {
    static let requestUrl = "https://itunes.apple.com/search?"
    static let mediaParam = "media=music"
}

//구조체의 인스턴스가 생성되지 않게 private init() {} 처리 해줘야함
struct Cell {
    static let musicCellIdentifier = "MusicCell"
    
    private init() {}
}
