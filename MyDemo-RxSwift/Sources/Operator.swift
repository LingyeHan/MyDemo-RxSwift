//
//  Operator.swift
//  MyDemo-RxSwift
//
//  Created by Lingye Han on 2019/6/18.
//

import Foundation
import RxSwift
import RxCocoa

public class Operator {
    
    let disposeBag = DisposeBag()
    
    func run() {
        amb()
        catchError()
        merge_combineLatest_zip()
        concat()
    }
    
    func amb() {
         print("### amb 只取一个先执行的Observable ###")
        let o1 = Observable<Int>.just(1)
        let o2 = Observable<Int>.just(2)
        let o3 = Observable<Int>.just(3)
        Observable<Int>.amb([o1, o2, o3])
            .subscribe { event in
                switch event {
                case .next(let element):
                    print("element:", element)
                case .error(let error):
                    print("error:", error)
                case .completed:
                    print("completed")
                }}
            .disposed(by: disposeBag)
    }
    
    func catchError() {
         print("### catchError 发生onError事件时将其拦截，并使用备用的序列替代它，再次执行操作 ###")
        let errorObservable = Observable<Int>.error(MyDemoError.fileNotFound)
        errorObservable
            .catchError({ error in
                print("catch:", error.localizedDescription)
                return Observable<Int>.just(666)
            })
            .subscribe { event in
                switch event {
                case .next(let element):
                    print("element:", element)
                case .error(let error):
                    print("error:", error)
                case .completed:
                    print("completed")
                }}
            .disposed(by: disposeBag)
        
        // catchErrorJustReturn
        let sequenceThatFails = PublishSubject<String>()
        sequenceThatFails
            .catchErrorJustReturn("😊")
            .subscribe { print($0) }
            .disposed(by: disposeBag)
        sequenceThatFails.onNext("😬")
        sequenceThatFails.onNext("😨")
        sequenceThatFails.onNext("😡")
        sequenceThatFails.onNext("🔴")
        sequenceThatFails.onError(MyDemoError.noManifest)
    }
    
    func merge_combineLatest_zip() {
        print("### combineLatest ###")
        let first = PublishSubject<String>()
        let second = PublishSubject<String>()
        
        Observable.of(first, second)
            .merge()
            .subscribe(onNext: { print("merge: " + $0) })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(first, second) { $0 + $1 }
            .subscribe(onNext: { print("combineLatest: " + $0) })
            .disposed(by: disposeBag)
        
        Observable.zip(first, second) { $0 + $1 }
            .subscribe(onNext: { print("zip: " + $0) })
            .disposed(by: disposeBag)
        
        first.onNext("1")
        second.onNext("A")
        first.onNext("2")
        second.onNext("B")
        //second.onError(MyDemoError.typeNotFound)
        second.onNext("C")
        second.onNext("D")
        first.onNext("3")
        first.onNext("4")
    }
    
    func concat() {
        let subject1 = BehaviorSubject(value: "🍎")
        let subject2 = BehaviorSubject(value: "🐶")
        
        let variable = BehaviorRelay(value: subject1)
        variable.asObservable()
            .concat()
            .subscribe { print($0) }
            .disposed(by: disposeBag)
        
        subject1.onNext("🍐")
        subject1.onNext("🍊")
        variable.accept(subject2)
        subject2.onNext("I would be ignored")
        subject2.onNext("🐱")
        subject1.onCompleted()
        subject2.onNext("🐭")
    }
    
}

// Errors
internal enum MyDemoError : Error {
    case noManifest
    case invalidManifest
    case fileNotFound
    case typeNotFound
    
    var description: String {
        switch self {
        case .noManifest:      return NSLocalizedString("No manifest file found", comment: "")
        case .invalidManifest: return NSLocalizedString("Invalid manifest.json file", comment: "")
        case .fileNotFound:    return "File specified in manifest.json not found in ZIP"
        case .typeNotFound:    return "Specified type not found in manifest.json"
        }
    }
}
