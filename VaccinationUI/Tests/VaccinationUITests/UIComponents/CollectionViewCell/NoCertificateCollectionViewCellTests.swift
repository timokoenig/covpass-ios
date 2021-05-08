//
//  NoCertificateCollectionViewCellTests.swift
//
//
//  Created by Daniel on 19.04.2021.
//

import Foundation
@testable import VaccinationUI
import XCTest

class NoCertificateCollectionViewCellTests: XCTestCase {
    // MARK: - Test Variables

    var sut: NoCertificateCollectionViewCell!

    // MARK: - Setup & Teardown

    override func setUp() {
        super.setUp()
        sut = createNoCertificateCell()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testSutNotNil() {
        XCTAssertNotNil(sut)
    }

    // MARK: - Mock Data

    private func createNoCertificateCell() -> NoCertificateCollectionViewCell? {
        let nib = UIConstants.bundle.loadNibNamed("\(NoCertificateCollectionViewCell.self)", owner: nil, options: nil)
        return nib?.first as? NoCertificateCollectionViewCell
    }
}
