//
//  DCCServiceMock.swift
//
//
//  © Copyright IBM Deutschland GmbH 2021
//  SPDX-License-Identifier: Apache-2.0
//

import CertLogic
import CovPassCommon
import Foundation
import PromiseKit

public enum DCCServiceMockError: Error {
    case invalidURL
}

class DCCServiceMock: DCCServiceProtocol {

    var loadDCCRulesResult: Promise<[RuleSimple]>?
    func loadDCCRules() -> Promise<[RuleSimple]> {
        loadDCCRulesResult ?? Promise.value([])
    }

    var loadDCCRuleResult: Promise<Rule>?
    func loadDCCRule(country _: String, hash _: String) -> Promise<Rule> {
        loadDCCRuleResult ?? Promise(error: DCCServiceMockError.invalidURL)
    }

    var loadValueSetsResult: Promise<[[String: String]]>?
    func loadValueSets() -> Promise<[[String : String]]> {
        loadValueSetsResult ?? Promise(error: DCCServiceMockError.invalidURL)
    }

    var loadValueSetResult: Promise<CovPassCommon.ValueSet>?
    func loadValueSet(id: String, hash: String) -> Promise<CovPassCommon.ValueSet> {
        loadValueSetResult ?? Promise(error: DCCServiceMockError.invalidURL)
    }

    func loadBoosterRules() -> Promise<[RuleSimple]> {
        #warning("remove")
        fatalError()
    }

    func loadBoosterRule(country: String, hash: String) -> Promise<Rule> {
        #warning("remove")
        fatalError()
    }
}
