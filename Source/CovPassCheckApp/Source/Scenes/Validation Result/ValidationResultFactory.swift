//
//  ValidationResultFactory.swift
//
//
//  © Copyright IBM Deutschland GmbH 2021
//  SPDX-License-Identifier: Apache-2.0
//

import CovPassCommon
import Foundation

struct ValidationResultFactory {
    static func createViewModel(router: ValidationResultRouterProtocol,
                                repository: VaccinationRepositoryProtocol,
                                certificate: CBORWebToken?,
                                error: Error?,
                                certLogic: DCCCertLogic = DCCCertLogic.create()) -> ValidationResultViewModel {
        guard let cert = certificate, error != nil else {
            return ErrorResultViewModel(router: router, repository: repository, error: error ?? CertificateError.invalidEntity)
        }

        do {
            // Validate given certificate based on GERMAN rules and users local time (CovPassCheck only)
            let validationResult = try certLogic.validate(countryCode: "DE", validationClock: Date(), certificate: cert)
            let valid = validationResult.contains(where: { $0.result != .passed }) == false

            // Show error dialog when at least one rule failed or there are no rules at all
            if !valid {
                return ErrorResultViewModel(router: router, repository: repository, certificate: certificate, error: CertificateError.expiredCertifcate)
            }
            if !validationResult.isEmpty {
                return ErrorResultViewModel(router: router, repository: repository, certificate: certificate, error: CertificateError.invalidEntity)
            }
            if certificate?.hcert.dgc.r?.isEmpty == false {
                return RecoveryResultViewModel(router: router, repository: repository, certificate: certificate)
            }
            if certificate?.hcert.dgc.t?.isEmpty == false {
                return TestResultViewModel(router: router, repository: repository, certificate: certificate)
            }
            return VaccinationResultViewModel(router: router, repository: repository, certificate: certificate)
        } catch {
            return ErrorResultViewModel(router: router, repository: repository, certificate: certificate, error: CertificateError.invalidEntity)
        }
    }
}
