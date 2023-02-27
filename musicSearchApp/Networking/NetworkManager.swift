//
//  NetworkManager.swift
//  musicSearchApp
//
//  Created by KimChoonSik on 2023/02/27.
//

import Foundation
// 네트워크 통신 에러 처리를 위한 에러 정의
enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}
//MARK: - 네트워킹 클래스 모델

final class Networkmanager {
    
    // 여러 화면(여러 객체)에서 네트워크 통신이 필요한 경우가 많기 때문에 주로 싱글톤 패턴으로 생성함
    // 접근이 용이하도록 타입 프로퍼티, Naming은 shared를 주로 사용
    static let shared = Networkmanager()
    //싱글톤 패턴 구현을 위한 생성자 - let a = NetworkManager() 같은 객체 생성 방지
    private init() {}
    
    // 콜백 함수가 길기 때문에 가독성을 위해 typealias 활용
    typealias NetworkCompletion = (Result<[Music], NetworkError>) -> Void
    
    //네트워킹 요청하는 함수 (음악 데이터 가져오기)
    //네트워킹의 경우 비동기처리를 하기 때문에, 리턴값이 있는 형태로 함수를 설계하면 안됨 -> 콜백함수 활용해야함
    //네트워크 통신 성공,실패 여부 처리를 위해 Result타입 사용
    func fetchMusic(searchTerm: String, completion: @escaping NetworkCompletion) {
        let urlString = "\(MusicApi.requestUrl)\(MusicApi.mediaParam)&term=\(searchTerm)"
        
        performRequest(with: urlString) { result in
            completion(result)
        }
    }
    
    //실제로 서버에 Request하는 함수 (비동기적 실행) -> 클로저 방식으로 끝난 시점을 전달 받음
    private func performRequest(with urlString: String, completion: @escaping NetworkCompletion) {
        
        // 1. Url 객체 생성
        guard let url = URL(string: urlString) else { return }
        // 2. Url Session 객체 생성 (브라우저의 탭바 같은 느낌으로 이해)
        let session = URLSession(configuration: .default)
        
        //비동기적으로 동작하는 dataTask(일시정지 상태로 시작해서 추후 resume 해줘야함)
        
        let task = session.dataTask(with: url) { data, response, error in
            //에러 여부 먼저 체크
            if error != nil {
                print(error!)
                completion(.failure(.networkingError))
                return
            }
            
            guard let safeData = data else {
                completion(.failure(.dataError))
                return
            }
            //Call to method 'parseJason' in closure requires explicit use of 'self' to make capture semantics explicit
            //클로저 캡처리스트 참고
            //현재 아래 코드가 클로저 안에서 실행되고 있음 (parseJason 함수가 나중에 실행됨)
            //명시적으로 클로저가 self를 캡처해서 메모리 누수가 일어나지 않도록 다른 추가적인 값의 참조를 방지하는것.
            if let musics = self.parseJason(safeData) {
                print("Parse 실행")
                completion(.success(musics))
            } else {
                print("Parse 실패")
                completion(.failure(.parseError))
            }
        }
        task.resume()
    }
    
    //Json Parsing 하는 함수 (decoding) 서버에서 Json 형식으로 받아온 데이터를 필요한 swift 형태로 바꾸는 과정
    private func parseJason(_ musicData: Data) -> [Music]? {
        //decode 함수가 에러를 던질 수 있는 함수이기에 do - catch 활용해 처리
    
        do { // MusicData 형태로 변환해야 하니, 메타타입을 파라미터로 넣어줘야함.
            let parsedData = try JSONDecoder().decode(MusicData.self, from: musicData)
            return parsedData.results
            //MusicData의 results 속성이 [Music] 형태임
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
}


