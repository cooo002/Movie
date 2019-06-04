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
    
    var dataSet = [("타크나이트", "영웅물에 철학과 음악이 더해져 에슐 작풀이 되다", "2009=8-09-04", 8.95, "darknight.jpg" ),
                   ("호후시절", "떼랄 알고 내리는 좋은 비", "2009-10-08", 7.31, "rain.jpg" ),
                   ("말할수 없는 비밀", "여시거 너까지 다섯 걸음", "2015-05-07", 9.19, "secret.jpg")
    ]
    // dataset 에 있는 튜플을 뽑아서 데이터 소스를 가지고 있는 객체에 각 변수로 할당한 뒤 그것을 리스트에 저장해야하낟
  lazy var list : [MovieVO] = { // 도대체 lazy를 붙이고 안 붙이고 차이가 뭐지??
        // 클로져 사용
        var datalist = [MovieVO]()
        
        for (title, des, opendate, rating, thumbnail) in self.dataSet{
            let mvo = MovieVO()
            mvo.title = title
            mvo.description = des
            mvo.opendate = opendate
            mvo.rating = rating
            mvo.thumbnail = thumbnail
            datalist.append(mvo)
            
        }
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
        cell.thumbnail.image = UIImage(named: row.thumbnail!) // UIImage생성자를 이미지 객첼를 생성할 때 매개변수로 실제 프로젝트 폴더 내에 존재하고 이미지 객체로 만들고 싶은 이미지의 파일명을 인자로 넘겨준다. UIImage(contentsOfFile:) 에서도 이미지명을 인자로 넘겨준다.
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // note 이 메소드는 특정 행을 선택했을 때 ios에 의해 자동으로 호출되는 함수이다.
        NSLog("선택된 행은 \(indexPath.row)")
    }
    
    
    override func viewDidLoad() {
     
        
    }
    
}

