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

let cbCentralManagerDelegateNotSet = CBCentralManagerDelegateNotSet()

class CBCentralManagerDelegateNotSet : NSObject, CBCentralManagerDelegate {
    
    var state: CBCentralManagerState! = .Unknown
    var restoreStateCallback: ((CBCentralManager, [String : AnyObject]!) -> ())?
    
    internal func centralManager(central: CBCentralManager, willRestoreState dict: [String : AnyObject]) {
        restoreStateCallback?(central, dict)
    }
    
    internal func centralManagerDidUpdateState(central: CBCentralManager) {
        state = central.state
    }
}

/// Proxy Object for CBCentralManagerDelegate
class RxCBCentralManagerDelegateProxy: DelegateProxy, CBCentralManagerDelegate, DelegateProxyType {
    
    let state = Variable<CBCentralManagerState!>(CBCentralManagerState.Unknown)
    
    class func currentDelegateFor(object: AnyObject) -> AnyObject? {
        let locationManager: CBCentralManager = object as! CBCentralManager
        return locationManager.delegate
    }
    
    class func setCurrentDelegate(delegate: AnyObject?, toObject object: AnyObject) {
        let locationManager: CBCentralManager = object as! CBCentralManager
        locationManager.delegate = delegate as? CBCentralManagerDelegate
    }
    
    internal func centralManagerDidUpdateState(central: CBCentralManager) {
        state.value = central.state
    }
    
}

extension CBCentralManager {
    
    public convenience init(withRx queue: dispatch_queue_t?, options: [String : AnyObject]?, restoreStateCallback: ((CBCentralManager, [String : AnyObject]!) -> ())?) {
        
        cbCentralManagerDelegateNotSet.restoreStateCallback = restoreStateCallback
        self.init(delegate: cbCentralManagerDelegateNotSet, queue: queue, options: options)
        (self.rx_delegate as! RxCBCentralManagerDelegateProxy).state.value = cbCentralManagerDelegateNotSet.state
    }

    
    /**
    Reactive wrapper for `delegate`.
    
    For more information take a look at `DelegateProxyType` protocol documentation.
    */
    public var rx_delegate: DelegateProxy {
        return proxyForObject(self) as RxCBCentralManagerDelegateProxy
    }
    
    /**
    Installs a delegate as forwarding delegate on `rx_delegate`.
    
    It enables using normal delegate mechanism with reactive delegate mechanism.
    
    - parameter delegate: Delegate object.
    - returns: Disposable object that can be used to unbind the delegate source.
    */
    public func rx_setDelegate(delegate: CBCentralManagerDelegate)
        -> Disposable {
            let proxy: RxCBCentralManagerDelegateProxy = proxyForObject(self)
            
            return installDelegate(proxy, delegate: delegate, retainDelegate: false, onProxyForObject: self)
    }
    
    // MARK: Responding to CB Central Manager
    
    /**
    Reactive wrapper for `delegate` message.
    */
    public var rx_didUpdateState: Observable<CBCentralManagerState!> {
        return (rx_delegate as! RxCBCentralManagerDelegateProxy).state.map {$0}
    }
    
    /**
    Reactive wrapper for `delegate` message.
    */
    public var rx_willRestoreState: Observable<[String : AnyObject]!> {
        return rx_delegate.observe("centralManager:willRestoreState:")
            .map { a in
                return a[1] as? [String : AnyObject]
        }
    }
    
    /**
    Reactive wrapper for `delegate` message.
    */
    public var rx_didDiscoverPeripheral: Observable<(CBPeripheral!, [String : AnyObject]!, NSNumber!)> {
        return rx_delegate.observe("centralManager:didDiscoverPeripheral:advertisementData:RSSI:")
            .map { a in
                return (a[1] as? CBPeripheral, a[2] as? [String : AnyObject], a[3] as? NSNumber)
        }
    }
    
    /**
    Reactive wrapper for `delegate` message.
    */
    public var rx_didConnectPeripheral: Observable<CBPeripheral!> {
        return rx_delegate.observe("centralManager:didConnectPeripheral:")
            .map { a in
                return a[1] as? CBPeripheral
        }
    }
    
    /**
    Reactive wrapper for `delegate` message.
    */
    public var rx_didFailToConnectPeripheral: Observable<(CBPeripheral!, NSError?)> {
        return rx_delegate.observe("centralManager:didFailToConnectPeripheral:error:")
            .map { a in
                return (a[1] as? CBPeripheral, a[2] as? NSError)
        }
    }
    
    /**
    Reactive wrapper for `delegate` message.
    */
    public var rx_didDisconnectPeripheral: Observable<(CBPeripheral!, NSError?)> {
        return rx_delegate.observe("centralManager:didDisconnectPeripheral:error:")
            .map { a in
                return (a[1] as? CBPeripheral, a[2] as? NSError)
        }
    }
    
}