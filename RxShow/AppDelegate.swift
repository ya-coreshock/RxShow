//
//  AppDelegate.swift
//  RxShow
//
//  Created by Alexey Aleshkov on 28/11/2017.
//  Copyright © 2017 Alexey Aleshkov. All rights reserved.
//

import UIKit
import RxSwift

class SaleListModule {
    let disposeBag = DisposeBag()

    deinit {
        print("SaleListModule deinit")
    }

    var cardModule: SaleCardModule?

    func openCard() {
        print("SaleListModule openCard enter")

        let module = SaleCardModule()

        module.resultObservable
            .map { !$0 }
            .map { !$0 }
            .filter { $0 }
            .do(onNext: { [weak self] _ in
                print("SaleCardModule resultObservable onNext")
                self?.cardModule = nil
            }, onDispose: {
                print("SaleCardModule resultObservable onDispose")
            })
            .subscribe()
            .disposed(by: disposeBag)

        cardModule = module

        print("SaleListModule openCard exit")
    }
}

class SaleCardModule {
    let resultSubject: PublishSubject<Bool> = PublishSubject()

    let resultObservable: Observable<Bool>

    init() {
        self.resultObservable = resultSubject.asObservable().do(onDispose: { print("disp") })

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
            self?.resultSubject.onNext(false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
                self?.resultSubject.onNext(true)
            })
        })
    }

    deinit {
//        resultSubject.onCompleted()
        print("SaleCardModule deinit")
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let saleListModule: SaleListModule = SaleListModule()
    weak var object: AnyObject?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        saleListModule.openCard()

        return true
    }
}
