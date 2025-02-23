//
//  UIImage+DS.swift
//
//
//  © Copyright IBM Deutschland GmbH 2021
//  SPDX-License-Identifier: Apache-2.0
//

import UIKit

public extension UIImage {
    @ImageLoader(name: "back_arrow")
    private(set) static var arrowBack

    @ImageLoader(name: "cancel")
    private(set) static var cancel

    @ImageLoader(name: "plus")
    private(set) static var plus

    @ImageLoader(name: "check")
    private(set) static var check

    @ImageLoader(name: "rg_arrow_down")
    private(set) static var arrowDown

    @ImageLoader(name: "onboarding_screen_1")
    private(set) static var onboardingScreen1

    @ImageLoader(name: "onboarding_screen_2")
    private(set) static var onboardingScreen2

    @ImageLoader(name: "onboarding_screen_3")
    private(set) static var onboardingScreen3

    @ImageLoader(name: "Illustration_consent")
    private(set) static var onboardingScreen4

    @ImageLoader(name: "illustration_1")
    private(set) static var illustration1

    @ImageLoader(name: "illustration_2")
    private(set) static var illustration2
    
    @ImageLoader(name: "illustration_3")
    private(set) static var illustration3
    
    @ImageLoader(name: "Illustration_4")
    private(set) static var illustration4
    
    @ImageLoader(name: "start_screen_1")
    private(set) static var startScreen

    @ImageLoader(name: "icon_lock")
    private(set) static var lock

    @ImageLoader(name: "chevron_right")
    private(set) static var chevronRight

    @ImageLoader(name: "Field-Right")
    private(set) static var FieldRight
    
    @ImageLoader(name: "button_close")
    private(set) static var close

    @ImageLoader(name: "scan_proof_image")
    private(set) static var proofScreen

    @ImageLoader(name: "settings_image")
    private(set) static var settings

    @ImageLoader(name: "status_full")
    private(set) static var statusFull

    @ImageLoader(name: "status_partial")
    private(set) static var statusPartial

    @ImageLoader(name: "star_full")
    private(set) static var starFull

    @ImageLoader(name: "star_partial")
    private(set) static var starPartial

    @ImageLoader(name: "help")
    private(set) static var help

    @ImageLoader(name: "no_vaccine_image")
    private(set) static var noCertificate

    @ImageLoader(name: "star_48px")
    private(set) static var starEmpty
    
    @ImageLoader(name: "prevention_label")
    private(set) static var completness
    
    @ImageLoader(name: "prevention")
    private(set) static var prevention

    @ImageLoader(name: "shield_lefthalf_fill")
    private(set) static var halfShield

    @ImageLoader(name: "icon_qr")
    private(set) static var scan

    @ImageLoader(name: "icon_share")
    private(set) static var share

    @ImageLoader(name: "icon_card")
    private(set) static var card

    @ImageLoader(name: "invalid")
    private(set) static var iconRed

    @ImageLoader(name: "info")
    private(set) static var iconYellow

    @ImageLoader(name: "map")
    private(set) static var map

    @ImageLoader(name: "delete")
    private(set) static var delete

    @ImageLoader(name: "warning")
    private(set) static var warning

    @ImageLoader(name: "checkbox_checked")
    private(set) static var checkboxChecked

    @ImageLoader(name: "checkbox_unchecked")
    private(set) static var checkboxUnchecked

    @ImageLoader(name: "result_success")
    private(set) static var resultSuccess
    
    @ImageLoader(name: "result_open")
    private(set) static var resultOpen

    @ImageLoader(name: "result_error")
    private(set) static var resultError

    @ImageLoader(name: "data")
    private(set) static var data

    @ImageLoader(name: "checkmark")
    private(set) static var validationCheckmark

    @ImageLoader(name: "pending")
    private(set) static var validationPending

    @ImageLoader(name: "search")
    private(set) static var validationSearch

    @ImageLoader(name: "group")
    private(set) static var group

    @ImageLoader(name: "status_full_detail")
    private(set) static var statusFullDetail

    @ImageLoader(name: "status_partial_detail")
    private(set) static var statusPartialDetail

    @ImageLoader(name: "icon_test")
    private(set) static var iconTest

    @ImageLoader(name: "calendar")
    private(set) static var calendar

    @ImageLoader(name: "time_hui")
    private(set) static var timeHui

    @ImageLoader(name: "technical_error")
    private(set) static var technicalError

    @ImageLoader(name: "error")
    private(set) static var error

    @ImageLoader(name: "expired")
    private(set) static var expired

    @ImageLoader(name: "activity")
    private(set) static var activity

    @ImageLoader(name: "status_expired")
    private(set) static var statusExpired
    
    @ImageLoader(name: "info_hui")
    private(set) static var info
    
    @ImageLoader(name: "signal_info_hui")
    private(set) static var infoSignal
    
    @ImageLoader(name: "flag_de")
    private(set) static var flagDE

    @ImageLoader(name: "status_full_notification")
    private(set) static var statusFullNotfication

    @ImageLoader(name: "flash-on")
    private(set) static var flashOn

    @ImageLoader(name: "flash-off")
    private(set) static var flashOff

    @ImageLoader(name: "status_partial_notification")
    private(set) static var statusPartialNotification

    @ImageLoader(name: "scan_please_illustration")
    private(set) static var scanPleaseIllustration

    @ImageLoader(name: "detail-status-full")
    private(set) static var detailStatusFull
    
    @ImageLoader(name: "detail-status-failed")
    private(set) static var detailStatusFailed
    
    @ImageLoader(name: "detail-status-full-empty")
    private(set) static var detailStatusFullEmpty
    
    @ImageLoader(name: "detail-status-test-empty")
    private(set) static var detailStatusTestEmpty
    
    @ImageLoader(name: "detail-status-test")
    private(set) static var detailStatusTest
    
    @ImageLoader(name: "icon-card-inverse")
    private(set) static var iconCardInverse
    
    @ImageLoader(name: "icon-card-inverse-warning")
    private(set) static var iconCardInverseWarning

    @ImageLoader(name: "detail-status-partial")
    private(set) static var detailStatusPartial

    @ImageLoader(name: "start-status-full-blue")
    private(set) static var startStatusFullBlue

    @ImageLoader(name: "start-status-full-white")
    private(set) static var startStatusFullWhite

    @ImageLoader(name: "status-expired-circle")
    private(set) static var statusExpiredCircle
}

@propertyWrapper
private struct ImageLoader {
    var wrappedValue: UIImage

    init(name: String) {
        guard let image = UIImage(named: name, in: Bundle.uiBundle, compatibleWith: nil) else {
            fatalError("Image: \(name) does not exist")
        }
        wrappedValue = image
    }
}
