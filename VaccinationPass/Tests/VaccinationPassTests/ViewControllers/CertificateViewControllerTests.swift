//
//  CertificateViewControllerTests.swift
//
//
//  Copyright © 2021 IBM. All rights reserved.
//

import Foundation
@testable import VaccinationPass
import VaccinationUI
import XCTest

class CertificateViewControllerTests: XCTestCase {
    // MARK: - Test Variables

    var sut: CertificateViewController!
    var viewModel: MockCertificateViewModel!

    // MARK: - Setup & Teardown

    override func setUp() {
        super.setUp()
        viewModel = MockCertificateViewModel()
        sut = CertificateViewController(viewModel: viewModel)
        // Load View
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = sut
    }

    override func tearDown() {
        viewModel = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testSutNotNil() {
        XCTAssertNotNil(sut)
    }

    func testCollectionView() {
        XCTAssertNotNil(sut.collectionView.delegate)
        XCTAssertNotNil(sut.collectionView.dataSource)
    }

    func testSetupActionButton() {
        XCTAssertNotNil(sut.addButton.action)
    }
}
