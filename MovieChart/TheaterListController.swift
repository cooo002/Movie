//
//  TheaterListController.swift
//  MovieChart
//
//  Created by 김재석 on 24/06/2019.
//  Copyright © 2019 김재석. All rights reserved.
//?s_page=0&s_list=100&type=json

import Foundation
import UIKit

class TheaterListController:UITableViewController {
    var list = [NSDictionary]() //Rest API를 통해서 읽어온 데이터를 딕셔너리 타입으로 저장 시키기 위한 객체이다.
    // 데이터를 읽어올 시작 위치이다.
    var startPoint = 0
    
    override func viewDidLoad() {
        self.callTheaterAPI()
    }
    
    func callTheaterAPI(){// Rest API를 이용해서 극장의 정보를 땡겨오기 위한 메소드이다.
        
        let requestURI = "http://115.68.183.178:2029/theater/list"
        let sList = 100 //  불어올 데이터 갯수
        
    let type = "json" // 불러올 데이터 타입
        // note: 위에서 정의한 인자값을 이용해서 URL 객체로 정의한다.
        let urlObj = URL(string: "\(requestURI)?s_page=\(self.startPoint)&s_list=\(sList)&type=\(type)")
       
        do{
       // NSStrting객체를 이용하여 Rest API를 호출하고 그 결과갑을 인코딩된 문자열로 받아온다.
            let stringdata = try NSString(contentsOf: urlObj!, encoding: 0x80_000_422)
            //문자열로 받은 데이터를 UTF-8로 인코딩 처리한 Data로 변환한다.
            let encdata = stringdata.data(using: String.Encoding.utf8.rawValue)
            
            do{
                
                let apiArray = try JSONSerialization.jsonObject(with: encdata!, options: []) as? NSArray
                //encdata라는 변수에 담겨진 Data 객체를 파싱하여 NSArray객체로 반환한다.
                for obj in apiArray!{
                    self.list.append(obj as! NSDictionary)
        // llst라는 배열에 일어온 데이터를 순회하면서 추가한다.
                    
                }
            }
                catch{ // 바로 위에 do에 대한 에러를 처리하는 부분이다.
                    let alert = UIAlertController(
                    title: "실패", message: "데이터 분석이 실패하였습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인 ", style: .cancel))
                    self.present(alert, animated: false)
                
                
                
                }
                
                self.startPoint += sList
                
                
        } catch{ // 맨 처음 do에 대한 에러를 처리하는 구문이다.
                let alert = UIAlertController(title: "실패", message: "데이터를 불러오는데 실패하였습니다.", preferredStyle: .alert
                    )
                alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                self.present(alert, animated: false)
            }
            
        }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = self.list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tCell") as! TheaterCell
        
        cell.name?.text = obj["상영관명"] as? String
        cell.tel?.text = obj["연락처"] as? String
        cell.addr?.text = obj["소재지도로명주소"] as? String
        
        
        return cell
    }
    
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if( segue.identifier == "segue_map"){
            
            let path = self.tableView.indexPath(for: sender as! UITableViewCell)
            let data = self.list[path!.row]

            (segue.destination as? TheaterViewController)?.param = data
        }
        
    }
    
        
    }

