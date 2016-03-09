//
//  CBPeripheral+Rx.swift
//  RxBluetooth
//
//  Created by Junior B. on 22/09/15.
//  Copyright © 2015 SideEffects. All rights reserved.
//

import Foundation
import CoreBluetooth
import RxSwift
import RxCocoa

/// Proxy Object for CBPeripheralDelegate
class RxCBPeripheralDelegateProxy: DelegateProxy, CBPeripheralDelegate, DelegateProxyType {
    
    class func currentDelegateFor(object: AnyObject) -> AnyObject? {
        let locationManager: CBPeripheral = object as! CBPeripheral
        return locationManager.delegate
    }
    
    class func setCurrentDelegate(delegate: AnyObject?, toObject object: AnyObject) {
        let locationManager: CBPeripheral = object as! CBPeripheral
        locationManager.delegate = delegate as? CBPeripheralDelegate
    }
}

extension CBPeripheral {
    
    /**
    Reactive wrapper for `delegate`.
    
    For more information take a look at `DelegateProxyType` protocol documentation.
    */
    public var rx_delegate: DelegateProxy {
        return proxyForObject(RxCBPeripheralDelegateProxy.self, self)
    }
    
    // MARK: Responding to CB Peripheral
    
    /**
    Reactive wrapper for `delegate` message.
    */
    public var rx_didUpdateName: Observable<String?> {
        return rx_delegate.observe("peripheralDidUpdateName:")
            .map { a in
                return (a[0] as? CBPeripheral)?.name
        }
    }
    
    /**
    Reactive wrapper for `delegate` message.
    */
    public var rx_didModifyServices: Observable<(CBPeripheral,[CBService]!)> {
        return rx_delegate.observe("peripheral:didModifyServices:")
            .map { a in
                return (a[0] as! CBPeripheral, a[1] as? [CBService])
        }
    }
    
    /**
    Reactive wrapper for `delegate` message.
    */
    @available(iOS 8.0, *)
    public var rx_didReadRSSI: Observable<(CBPeripheral, NSNumber!, NSError?)> {
        return rx_delegate.observe("peripheral:didReadRSSI:error:")
            .map { a in
                return (a[0] as! CBPeripheral, a[1] as? NSNumber, a[2] as? NSError)
        }
    }

    /**
    Reactive wrapper for `delegate` message.
    */

    public var rx_didDiscoverServices: Observable<(CBPeripheral!, [CBService]?, NSError?)> {
        return rx_delegate.observe("peripheral:didDiscoverServices:")
            .map { a in
                return (a[0] as? CBPeripheral, self.services, a[1] as? NSError)
        }
    }

    /**
    Reactive wrapper for `delegate` message.
    */

    public var rx_didDiscoverIncludedServicesForService: Observable<(CBPeripheral!, CBService!, NSError?)> {
        return rx_delegate.observe("peripheral:didDiscoverIncludedServicesForService:error:")
            .map { a in
                return (a[0] as? CBPeripheral, a[1] as? CBService, a[2] as? NSError)
        }
    }

    /**
    Reactive wrapper for `delegate` message.
    */

    public var rx_didDiscoverCharacteristicsForService: Observable<(CBPeripheral!, CBService!, NSError?)> {
        return rx_delegate.observe("peripheral:didDiscoverCharacteristicsForService:error:")
            .map { a in
                return (a[0] as? CBPeripheral, a[1] as? CBService, a[2] as? NSError)
        }
    }

    /**
    Reactive wrapper for `delegate` message.
    */

    public var rx_didUpdateValueForCharacteristic: Observable<(CBPeripheral!, CBCharacteristic!, NSError?)> {
        return rx_delegate.observe("peripheral:didUpdateValueForCharacteristic:error:")
            .map { a in
                return (a[0] as? CBPeripheral, a[1] as? CBCharacteristic, a[2] as? NSError)
        }
    }

    /**
    Reactive wrapper for `delegate` message.
    */

    public var rx_didWriteValueForCharacteristic: Observable<(CBPeripheral!, CBCharacteristic!, NSError?)> {
        return rx_delegate.observe("peripheral:didWriteValueForCharacteristic:error:")
            .map { a in
                return (a[0] as? CBPeripheral, a[1] as? CBCharacteristic, a[2] as? NSError)
        }
    }

    /**
    Reactive wrapper for `delegate` message.
    */

    public var rx_didUpdateNotificationStateForCharacteristic: Observable<(CBPeripheral!, CBCharacteristic!, NSError?)> {
        return rx_delegate.observe("peripheral:didUpdateNotificationStateForCharacteristic:error:")
            .map { a in
                return (a[0] as? CBPeripheral, a[1] as? CBCharacteristic, a[2] as? NSError)
        }
    }

    /**
    Reactive wrapper for `delegate` message.
    */

    public var rx_didDiscoverDescriptorsForCharacteristic: Observable<(CBPeripheral!, CBCharacteristic!, NSError?)> {
        return rx_delegate.observe("peripheral:didDiscoverDescriptorsForCharacteristic:error:")
            .map { a in
                return (a[0] as? CBPeripheral, a[1] as? CBCharacteristic, a[2] as? NSError)
        }
    }

    /**
    Reactive wrapper for `delegate` message.
    */

    public var rx_didUpdateValueForDescriptor: Observable<(CBPeripheral!, CBDescriptor!, NSError?)> {
        return rx_delegate.observe("peripheral:didUpdateValueForDescriptor:error:")
            .map { a in
                return (a[0] as? CBPeripheral, a[1] as? CBDescriptor, a[2] as? NSError)
        }
    }

    /**
    Reactive wrapper for `delegate` message.
    */

    public var rx_didWriteValueForDescriptor: Observable<(CBPeripheral!, CBDescriptor!, NSError?)> {
        return rx_delegate.observe("peripheral:didWriteValueForDescriptor:error:")
            .map { a in
                return (a[0] as? CBPeripheral, a[1] as? CBDescriptor, a[2] as? NSError)
        }
    }

}