//
//  Music.swift
//  musicSearchApp
//
//  Created by KimChoonSik on 2023/02/27.
//

import Foundation

//MARK: - 데이터 모델

// 애플 API : https://performance-partners.apple.com/search-api

// 요청 URL : https://itunes.apple.com/search?parameterkeyvalue
// parameterkeyvalue 자리에 key1=value1&key2=value2&key3=value3와 같은 형식으로 요청하면 됨
//ex: https://itunes.apple.com/search?term=pop&media=music

//데이터를 받아온 다음 https://app.quicktype.io/ 사이트를 활용하면 손쉽게 원하는 형태로 변환 가능
//필요한 데이터만 남기고 정리한다.

struct MusicData: Codable {
    let resultCount: Int
    let results: [Music]
}
//일반적으로 open api를 사용하면 get방식이 대부분이며, 서버에서 받아와 표시만 하는 경우이기에 구조체로 만듦

struct Music: Codable {
    let songName: String?
    let artistName: String?
    let albumName: String?
    let previewUrl: String?
    let imageUrl: String?
    private let releaseDate: String?
    
    // 네트워크에서 주는 이름을 변환하는 방법 (원시값) api를 통해 전달받은 데이터 식별이 어려운 경우 CodingKeys를 활용할 수 있음.
    // (서버: trackName ===> songName)
    enum CodingKeys: String, CodingKey {
        case songName = "trackName"
        case artistName
        case albumName = "collectionName"
        case previewUrl
        case imageUrl = "artworkUrl100"
        case releaseDate
    }
    //서버에서 넘어오는 날짜 데이터가 "2011-07-05T12:00:00Z"와 같은 형식이라, "yyyy-MM-dd"로 표시해주기 위한 계산속성 선언
    var releaseDateString: String? {
        //get 블럭이 생략되었다고 보면 됨
        // ISO 규약에 따른 문자열 형태로 넘어오기 때문에 아래 코드를 통해 처리
        guard let isoDate = ISO8601DateFormatter().date(from: releaseDate ?? "") else { return "" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: isoDate)
        return dateString
    }
    
    
}
