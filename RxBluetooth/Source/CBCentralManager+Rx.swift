//
//  CBCentralManager+Rx.swift
//  RxBluetooth
//
//  Created by Junior B. on 22/09/15.
//  Copyright © 2015 SideEffects. All rights reserved.
//

import Foundation
import CoreBluetooth
import RxSwift
import RxCocoa

/// Proxy Object for CBCentralManagerDelegate
class RxCBCentralManagerDelegateProxy: DelegateProxy, CBCentralManagerDelegate, DelegateProxyType {

    let _didUpdateState = ReplaySubject<CBCentralManagerState>.create(bufferSize: 1)

    class func currentDelegateFor(object: AnyObject) -> AnyObject? {
        let centralManager: CBCentralManager = object as! CBCentralManager
        return centralManager.delegate
    }

    class func setCurrentDelegate(delegate: AnyObject?, toObject object: AnyObject) {
        let centralManager: CBCentralManager = object as! CBCentralManager
        centralManager.delegate = delegate as? CBCentralManagerDelegate
    }

    internal func centralManagerDidUpdateState(central: CBCentralManager) {
        _didUpdateState.on(.Next(central.state))
        self._forwardToDelegate?.centralManagerDidUpdateState?(central)
    }

    deinit {
        _didUpdateState.on(.Completed)
    }
}

extension CBCentralManager {

    /**
    Reactive wrapper for `delegate`.

    For more information take a look at `DelegateProxyType` protocol documentation.
    */
    public var rx_delegate: DelegateProxy {
        return RxCBCentralManagerDelegateProxy(parentObject: self)
    }

    // MARK: Responding to CB Central Manager

    /**
    Reactive wrapper for `delegate` message.
    */
    public var rx_didUpdateState: ControlEvent<CBCentralManagerState> {
        let proxy = RxCBCentralManagerDelegateProxy(parentObject: self)
        return ControlEvent(events: proxy._didUpdateState)
    }

    /**
    Reactive wrapper for `delegate` message.
    */
    public var rx_willRestoreState: Observable<[String : AnyObject]!> {
        return rx_delegate.observe(#selector(CBCentralManagerDelegate.centralManager(_:willRestoreState:)))
            .map { a in
                return a[1] as? [String : AnyObject]
        }
    }

    /**
    Reactive wrapper for `delegate` message.
    */
    public var rx_didDiscoverPeripheral: Observable<(CBPeripheral!, [String : AnyObject]!, NSNumber!)> {
        return rx_delegate.observe(#selector(CBCentralManagerDelegate.centralManager(_:didDiscoverPeripheral:advertisementData:RSSI:)))
            .map { a in
                return (a[1] as? CBPeripheral, a[2] as? [String : AnyObject], a[3] as? NSNumber)
        }
    }

    /**
    Reactive wrapper for `delegate` message.
    */
    public var rx_didConnectPeripheral: Observable<CBPeripheral!> {
        return rx_delegate.observe(#selector(CBCentralManagerDelegate.centralManager(_:didConnectPeripheral:)))
            .map { a in
                return a[1] as? CBPeripheral
        }
    }

    /**
    Reactive wrapper for `delegate` message.
    */
    public var rx_didFailToConnectPeripheral: Observable<(CBPeripheral!, NSError?)> {
        return rx_delegate.observe(#selector(CBCentralManagerDelegate.centralManager(_:didFailToConnectPeripheral:error:)))
            .map { a in
                return (a[1] as? CBPeripheral, a[2] as? NSError)
        }
    }

    /**
    Reactive wrapper for `delegate` message.
    */
    public var rx_didDisconnectPeripheral: Observable<(CBPeripheral!, NSError?)> {
        return rx_delegate.observe(#selector(CBCentralManagerDelegate.centralManager(_:didDisconnectPeripheral:error:)))
            .map { a in
                return (a[1] as? CBPeripheral, a[2] as? NSError)
        }
    }

}
