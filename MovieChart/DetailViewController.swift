//
//  DetailViewController.swift
//  MovieChart
//
//  Created by 김재석 on 10/06/2019.
//  Copyright © 2019 김재석. All rights reserved.
//

import Foundation
import WebKit

class DetailViewController: UIViewController {
    // note :  웹뷰가 올라간 뷰 컨트롤러와 연결시킬 커스텀 클래스다.
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var wv: WKWebView!
    
    var mvo : MovieVO!
    
    override func viewDidLoad() {
        self.wv.navigationDelegate = self
        
        NSLog("this is webView checking !!! linkurl = \(self.mvo.detail!) ,title=\(self.mvo.title!)")
        // note: 그냥 체킹요 로그를 출력하느 코드이다.
        let navibar = self.navigationItem
        navibar.title = self.mvo.title!
        //note: 네비게이션 아이템의 타이들을 지정하느 코드이다.
        
        let url  = URL(string: (self.mvo.detail)!)
        let req = URLRequest(url: url!)
        
        
        self.wv.load(req)
        
        //note : WkWebView 객체를 이용해서 웹 페이즐 띄우는 코드 (UIWebView객체를 사용하는 것과 웹 뷰로 웹 페이지를 띄우는 것은 같지만 사용되는 메소드는 다르다. !)
    }
    
}
//MARk:-WKNavigationDelegate 프로토콜 구현

extension DetailViewController:WKNavigationDelegate{
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.spinner.startAnimating()//note 웹 뷰가 퓁 페이지의 콘테츠를 읽어드리기 시작할 때 이 메소드가 실행되고 그럼 이 코드가 실행되어서 로딩 아이콘이 실해된느 것이다 .

    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.spinner.stopAnimating()// 웹 뷰가 페이지의 컨텐츠를 읽어오는 과정이 끝나면 이 메소드가 자동으로 호출된다.( 처음에 로딩 아이콘의 어트리뷰트 인스펙터 탭에서 "Hiddes When Stopped"를 선택해서 이것이 가능한거이단 저걸 체크해서 로딩 아이콘의 애니메이션이 멈추면 감춰지게 되는 것이다.)
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.spinner.stopAnimating()//note: 어떤 사정이 생겨 웹 뷰가 웹 페이지를 읽어오지 못 한다면  로딩 아이콘도 멈춰줘야하다.
        let alert = UIAlertController(title: "오류", message: "상세페이지를 읽어오지 못 했습니다.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "확인", style: .cancel, handler: { (_) in// _은 실행부가 실해된뒤 반환타입
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(cancel)
        self.present(alert, animated: false, completion: nil)
        
    }
    
}

//extension UIViewController{

//}
