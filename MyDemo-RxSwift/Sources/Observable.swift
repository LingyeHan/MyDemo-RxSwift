//
//  Observable.swift
//  MyDemo-RxSwift
//
//  Created by Lingye Han on 2019/7/23.
//  Copyright © 2019 Hanly. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/// 序列
public class ObservableDemo {
    
    static let shared = ObservableDemo()
    
    let disposeBag = DisposeBag()
    
    func run() {
        print("\(NSStringFromClass(ObservableDemo.self)) run()")
        never()
        empty()
        just()
        of()
        from()
        create()
        range()
        repeatElement()
        generate()
        error()
    }
    
    /// 构建一个从不终止和发出任何事件的队列
    func never() {
        Observable<String>.never()
            .subscribe { _ in
                print("This will never be printed")
            }
            .disposed(by: disposeBag)
    }
    
    /// 构建一个空的Observable队列，只发出完成事件
    func empty() {
        Observable<Int>.empty()
            .subscribe { event in
                print("\(#function) => \(event)")
            }
            .disposed(by: disposeBag)
    }
    
    /// 构建一个只有一个元素的Observable队列
    func just() {
        Observable<Int>.just(123)
            .subscribe { event in
                print("\(#function) => \(event)")
            }
            .disposed(by: disposeBag)
    }
    
    /// 构建一个拥有固定数量元素的Observable序列
    func of() {
        Observable.of("A", "B", "C", "D")
            .subscribe(onNext: { element in
                print("\(#function) => \(element)")
            })
            .disposed(by: disposeBag)
    }
    
    /// 从序列中创建可观察到的序列，如数组、字典或集合
    func from() {
        Observable.from(["🐶", "🐱", "🐭", "🐹"])
            .subscribe(onNext: {
                print("\(#function) => \($0)")
            })
            .disposed(by: disposeBag)
    }
    
    /// 构建一个自定义的可观察序列
    func create() {
        let myJust = { (element: String) -> Observable<String> in
            return Observable.create { observer in
                observer.on(.next(element))
                observer.on(.completed)
                return Disposables.create()
            }
        }
        myJust("🔴")
            .subscribe { print("\(#function) => \($0)") }
            .disposed(by: disposeBag)
    }
    
    /// 创建一个可观察序列，该序列释放一系列连续整数，然后终止
    func range() {
        Observable.range(start: 1, count: 10)
            .subscribe { print("\(#function) => \($0)") }
            .disposed(by: disposeBag)
    }
    
    /// 创建一个可观察到的序列，它无限地释放给定的元素
    func repeatElement() {
        Observable.repeatElement("123")
            .take(3)
            .subscribe(onNext: {print("\(#function) => \($0)") })
            .disposed(by: disposeBag)
    }
    
    /// 创建一个可观察的序列，只要所提供的条件求值为true，就生成值
    func generate() {
        Observable.generate(
            initialState: 0,
            condition: { $0 < 3 },
            iterate: { $0 + 1 }
            )
            .subscribe(onNext: { print("\(#function) => \($0)") })
            .disposed(by: disposeBag)
    }
    
    /// 创建一个没有任何元素的可观察序列，并立即以错误结束
    func error() {
        Observable<Int>.error(CocoaError(CocoaError.coderValueNotFound, userInfo: ["message" : "test"]))
            .subscribe { print("\(#function) => \($0)") }
            .disposed(by: disposeBag)
    }
}
