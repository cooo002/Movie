// note :  테이블 뷰 컨트롤러의 커스텀 클래스
//  ListViewController.swift
//  MovieChart
//
//  Created by 김재석 on 02/06/2019.
//  Copyright © 2019 김재석. All rights reserved.
//

import Foundation
import UIKit

class ListViewTableController : UITableViewController  {
    
    var page = 1
    
    @IBOutlet weak var moreBtn: UIView!
    //    var dataSet = [("타크나이트", "영웅물에 철학과 음악이 더해져 에슐 작풀이 되다", "2009=8-09-04", 8.95, "darknight.jpg" ),
//                   ("호후시절", "떼랄 알고 내리는 좋은 비", "2009-10-08", 7.31, "rain.jpg" ),
//                   ("말할수 없는 비밀", "여시거 너까지 다섯 걸음", "2015-05-07", 9.19, "secret.jpg")
//    ]
    // dataset 에 있는 튜플을 뽑아서 데이터 소스를 가지고 있는 객체에 각 변수로 할당한 뒤 그것을 리스트에 저장해야하낟
  lazy var list : [MovieVO] = { // 도대체 lazy를 붙이고 안 붙이고 차이가 뭐지??
        // 클로져 사용
        var datalist = [MovieVO]()
        
//        for (title, des, opendate, rating, thumbnail) in self.dataSet{
//            let mvo = MovieVO()
//            mvo.title = title
//            mvo.description = des
//            mvo.opendate = opendate
//            mvo.rating = rating
//            mvo.thumbnail = thumbnail
//            datalist.append(mvo)
//
//        }
        return datalist
       
        
    }()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //note : 여기서 반환하는 수 만큼 ios시스템에서 데이블 뷰에 셀을 을 만들어준다.
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // note 위에 tableview 메소드가 반화는 수 만큼 셀이 만들어지는데 순서대로 셀을 하난 만들 때 마다 이 메소드로 실행된다. 이 때 그 셀에 해당되는 모든 정보를 위 메소드에 indexPath로 전달하게된다.
        let row = self.list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! MovieCell
        // note: Identifier를 사용하고자하는 프로토타입 셀의 identifier와 일치해줘야 된다. 이렇게 지정한 프로토타입 셀이 따로 커스텀 클래스가 정의되었고 그 클래스이 이름이 MovieCell이다
        
        cell.title?.text = row.title//MovieCell 클래스에 아울엣 변수로 프로토타입 셀 위에 객체 중하는 정의하였는데 그걸 가져와사
        //사용함
        cell.desc?.text = row.description // ""
        cell.opendate?.text = row.opendate// ""
        cell.rating?.text = "\(row.rating)" // ""
//        cell.thumbnail.image = UIImage(named: row.thumbnail!) // UIImage생성자를 이미지 객첼를 생성할 때 매개변수로 실제 프로젝트 폴더 내에 존재하고 이미지 객체로 만들고 싶은 이미지의 파일명을 인자로 넘겨준다. UIImage(contentsOfFile:) 에서도 이미지명을 인자로 넘겨준다.
        let url: URL! = URL(string: row.thumbnail!)
        
        let imageData = try! Data(contentsOf: url)
         cell.thumbnail.image = UIImage(data: imageData)
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // note 이 메소드는 특정 행을 선택했을 때 ios에 의해 자동으로 호출되는 함수이다.
        NSLog("선택된 행은 \(indexPath.row)")
    }
    
    
    override func viewDidLoad() {
        self.callMovieAPI()
     
        
    }
    
    
    @IBAction func more(_ sender: Any) {
    
    self.page += 1
    self.callMovieAPI()
        
        self.tableView.reloadData()
    }
    
    
    
    func callMovieAPI(){
        
        let url =  "http://115.68.183.178:2029/hoppin/movies?order=releasedateasc&count=10&page=\(self.page)&version=1&genreId="
        let apiURI: URL! = URL(string: url)
        //note 2.  Rest API에 요청을 보내고 그에 따른 응답 데이터를 Data() 라는 객체에 담아둔다.
        
        let apidata = try! Data(contentsOf: apiURI)
        
        // note 3. 받아온 데이터를 로그로 뿌려준다
        let log = NSString(data: apidata, encoding: String.Encoding.utf8.rawValue) ?? ""
        //note: Date() 객체에 담긴 데이터가 바이너리 파일이라면 문자열 변환에 실패하고 nil을 반환한다. 그리고
        //이렇게 NString()이 반환하는 값이 만약 nil이라면 ""왁 같이 문자열을 반환하게 되는 것이다.
        
        NSLog("API Result = \( log )")
        // note: 이 부분은 부터는 응답 데이터를 파싱하는 코드이다
        
        do {
            
            let apiDictionary = try JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary
            // 1.JSONSerialization은 json 객체를  NSDictionary로 변환해주는 코드다 근데 이때 변환을 하면 가장 밖에 있는것 하나만 NSDictioary 타입을 ㅗ변환되는 것이다. 그 안에 속해 있는 것은 나중에 사용하려면 또 변환해줘한다.
            
            
            // 2. 데이터 구조에 따라 차례대로 캐스팅하며 읽어온다.
            let hoppin = apiDictionary["hoppin"] as! NSDictionary
            let movies = hoppin["movies"] as! NSDictionary
            let movie = movies["movie"] as! NSArray
            // 3. Iterator 처리를 하면서 REST API의 응답 데이터에서 필요한 부분은 MovieVO 객체에 저장한다.
            let totalCount = (hoppin["totalCount"]as? NSString)!.integerValue
            
            for row in movie {
                
                // movie는 NSArray 타입인데 그안에 있는 데이터는 {}로 이루어져 있다. 즉 이 말은 NSDictionary타입으로 캐스팅해야한다.
                let r = row as! NSDictionary
                
                let mvo = MovieVO()
                
                mvo.title = r["title"] as? String
                mvo.description = r["genreNames"] as? String
                mvo.thumbnail = r["thumbnailImage"] as? String
                mvo.detail = r["linkUrl"] as? String
                mvo.rating = ((r["ratingAverage"] as! NSString).doubleValue)
                
                // list 라는 배열의 추가
                self.list.append(mvo)
                
                if( self.list.count >= totalCount){
                    
                    self.moreBtn.isHidden = true
                }
            }
            
            
            
            
        } catch{
            // note: catxh부분이다.
            NSLog("Parse Error!!")
        }
        
        
    }
    
    
}

