//
//  ViewController.swift
//  MyDemo-RxSwift
//
//  Created by LingyeHan on 06/17/2019.
//  Copyright (c) 2019 LingyeHan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Why Use Swift
        //targetAction()
        delegate()
        closureCallback()
        notification()
        multiTaskDependOn()
        multiTaskCombineCompletedProcessResult()
        
        // Operator
        let operatorDemo = Operator()
        
        button.rx.tap
            .subscribe(onNext: {
                operatorDemo.run()
            })
            .disposed(by: disposeBag)
    }
    
    
    func targetAction() {
        //button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.rx.tap.subscribe(onNext: {
            print("button Tapped")
        })
        .disposed(by: disposeBag)
    }
    
    func delegate() {
        tableView.rx.contentOffset
            .subscribe(onNext: { contextOffset in
                print("contextOffset: \(contextOffset)")
            })
            .disposed(by: disposeBag)
    }
    
    func closureCallback() {
        guard let url = URL(string: "https://www.baidu.com/") else {
            return
        }
//        URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, error) in
//            guard error == nil else {
//                print("Data Task Error: \(error!)")
//                return
//            }
//
//            guard let data = data else {
//                print("Data Task Error: unknown")
//                return
//            }
//
//            print("Data Task Success with count: \(data.count)")
//        }.resume()
        
        URLSession.shared.rx.data(request: URLRequest(url: url))
            .subscribe(onNext: { data in
                print("Data Task Success with count: \(data.count)")
            }, onError: { (error) in
                print("Data Task Error: \(error)")
            }, onCompleted: {
                print("Data Task Complete")
            }).disposed(by: disposeBag)
    }
    
    func notification() {
        NotificationCenter.default.rx
            .notification(UIApplication.willEnterForegroundNotification)
            .subscribe(onNext: { (notification) in
                print("Application will enter foreground")
            }).disposed(by: disposeBag)
    }
    
    /// 多个任务之间有依赖关系(避免回调地狱，从而使得代码易读，易维护)
    func multiTaskDependOn() {
        // 用 Rx 封装接口
        enum API {
            
            /// 通过用户名密码取得一个 token
            //static func token(username: String, password: String) -> Observable<String> { ... }
            
            /// 通过 token 取得用户信息
            //static func userInfo(token: String) -> Observable<UserInfo> { ... }
        }
        
        /// 通过用户名和密码获取用户信息
//        API.token(username: "beeth0ven", password: "987654321")
//            .flatMapLatest(API.userInfo)
//            .subscribe(onNext: { userInfo in
//                print("获取用户信息成功: \(userInfo)")
//            }, onError: { error in
//                print("获取用户信息失败: \(error)")
//            })
//            .disposed(by: disposeBag)
    }
    
    func multiTaskCombineCompletedProcessResult() {
        /// 用 Rx 封装接口
        enum API {
            
            /// 取得老师的详细信息
            //static func teacher(teacherId: Int) -> Observable<Teacher> { ... }
            
            /// 取得老师的评论
            //static func teacherComments(teacherId: Int) -> Observable<[Comment]> { ... }
        }
        /// 同时取得老师信息和老师评论
//        Observable.zip(
//            API.teacher(teacherId: teacherId),
//            API.teacherComments(teacherId: teacherId)
//            ).subscribe(onNext: { (teacher, comments) in
//                print("获取老师信息成功: \(teacher)")
//                print("获取老师评论成功: \(comments.count) 条")
//            }, onError: { error in
//                print("获取老师信息或评论失败: \(error)")
//            })
//            .disposed(by: disposeBag)
    }

}

