// Copyright 2022-2023 Chartboost, Inc.
// 
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

//
//  Busy.swift
//  ChartboostMediationDemo
//
//  Copyright © 2023 Chartboost. All rights reserved.
//

import UIKit

/// Functionality that is relevant for this demo only. It is not applicable to anything specific to the Chartboost Mediation SDK.

class BusyViewController: UIViewController {

    class func present(over parent: UIViewController) -> UIViewController {
        let storyboard = UIStoryboard(name: "Busy", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Busy")
        parent.present(vc, animated: true)
        return vc
    }
}

private var busyObjectHandle: UInt8 = 0

extension UIViewController: ActivityDelegate {
    var busy: UIViewController? {
        get {
            return objc_getAssociatedObject(self, &busyObjectHandle) as? UIViewController
        }
        set {
            objc_setAssociatedObject(self, &busyObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func activityDidStart() {
        busy = BusyViewController.present(over: self)
    }

    func activityDidEnd() {
        busy?.dismiss(animated: true, completion: {
            self.busy = nil
        })
    }

    func activityDidEnd(message: String, error: Error?) {
        if let busy = busy {
            busy.dismiss(animated: true, completion: {
                self.busy = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.presentAlert(message: message, error: error)
                }
            })
        }
        else {
            presentAlert(message: message, error: error)
        }
    }
}
