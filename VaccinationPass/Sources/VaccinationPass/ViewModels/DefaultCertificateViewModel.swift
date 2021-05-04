//
//  DefaultCertificateViewModel.swift
//  
//
//  Copyright © 2021 IBM. All rights reserved.
//

import Foundation
import UIKit
import VaccinationUI
import VaccinationCommon
import PromiseKit

public class DefaultCertificateViewModel: CertificateViewModel {
    // MARK: - Parser
    
    private let repository: VaccinationRepositoryProtocol
    
    public init(repository: VaccinationRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - HeadlineViewModel
    
    public var headlineTitle = "vaccination_certificate_list_title".localized
    public var headlineButtonImage: UIImage? = .help
    
    // MARK: - CertificateViewModel
    
    public weak var delegate: ViewModelDelegate?
    public var addButtonImage: UIImage? = .plus

    public var certificates = [BaseCertifiateConfiguration]()
    public var certificateList = VaccinationCertificateList(certificates: [])
    public var matchedCertificates: [ExtendedCBORWebToken] {
        let certs = self.sortFavorite(certificateList.certificates, favorite: certificateList.favoriteCertificateId ?? "")
        return self.matchCertificates(certs)
    }

    public func process(payload: String) -> Promise<ExtendedCBORWebToken> {
        return repository.scanVaccinationCertificate(payload).then({ cert in
            return self.repository.getVaccinationCertificateList().map({ list in
                self.certificates = list.certificates.map { self.getCertficateConfiguration(for: $0.vaccinationCertificate.hcert.dgc) }
                return cert
            })
        })
    }

    public func loadCertificatesConfiguration() {
        repository.getVaccinationCertificateList().map({ list -> [ExtendedCBORWebToken] in
            self.certificateList = list
            return self.matchedCertificates
        }).done({ list in
            if list.isEmpty {
                self.certificates = [self.noCertificateConfiguration()]
                return
            }
            self.certificates = list.map { self.getCertficateConfiguration(for: $0.vaccinationCertificate.hcert.dgc) }
        }).catch({ error in
            print(error)
            self.certificates = [self.noCertificateConfiguration()]
        }).finally({
            self.delegate?.shouldReload()
        })
    }

    private func sortFavorite(_ certificates: [ExtendedCBORWebToken], favorite: String) -> [ExtendedCBORWebToken] {
        guard let favoriteCert = certificates.first(where: { $0.vaccinationCertificate.hcert.dgc.v.first?.ci == favorite }) else { return certificates }
        var list = [ExtendedCBORWebToken]()
        list.append(favoriteCert)
        list.append(contentsOf: certificates.filter({ $0 != favoriteCert }))
        return list
    }

    private func matchCertificates(_ certificates: [ExtendedCBORWebToken]) -> [ExtendedCBORWebToken] {
        var list = [ExtendedCBORWebToken]()
        var certs: [ExtendedCBORWebToken] = certificates.reversed()
        while certs.count > 0 {
            guard let cert = certs.popLast() else { return list }
            let pair = findCertificatePair(cert, certs)
            certs.removeAll(where: { pair.contains($0) })

            if let fullCert = pair.first(where: { $0.vaccinationCertificate.hcert.dgc.fullImmunization
            }) {
                list.append(fullCert)
            } else if let partialCert = pair.last {
                list.append(partialCert)
            }
        }
        return list
    }

    private func findCertificatePair(_ certificate: ExtendedCBORWebToken, _ certificates: [ExtendedCBORWebToken]) -> [ExtendedCBORWebToken] {
        var list = [certificate]
        for cert in certificates where certificate.vaccinationCertificate.hcert.dgc == cert.vaccinationCertificate.hcert.dgc {
            if !list.contains(cert) {
                list.append(cert)
            }
        }
        return list
    }
    
    public func configure<T: CellConfigutation>(cell: T, at indexPath: IndexPath)  {
        guard certificates.indices.contains(indexPath.row) else { return }
        let configuration = certificates[indexPath.row]
        if let noCertificateCell = cell as? NoCertificateCollectionViewCell, let noCertificateConfig = configuration as? NoCertifiateConfiguration {
            noCertificateCell.configure(with: noCertificateConfig)
        } else if let qrCertificateCell = cell as? QrCertificateCollectionViewCell, let qrCertificateConfig = configuration as? QRCertificateConfiguration {
            qrCertificateCell.configure(with: qrCertificateConfig)
        }
    }
    
    public func reuseIdentifier(for indexPath: IndexPath) -> String {
        guard certificates.indices.contains(indexPath.row) else {
            return "\(NoCertificateCollectionViewCell.self)"}
        return certificates[indexPath.row].identifier
    }

    public func detailViewModel(_ indexPath: IndexPath) -> VaccinationDetailViewModel? {
        if matchedCertificates.isEmpty {
            return nil
        }
        let pair = findCertificatePair(matchedCertificates[indexPath.row], certificateList.certificates)
        return VaccinationDetailViewModel(certificates: pair, repository: self.repository)
    }

    public func detailViewModel(_ cert: ExtendedCBORWebToken) -> VaccinationDetailViewModel? {
        if certificateList.certificates.isEmpty {
            return nil
        }
        let pair = findCertificatePair(cert, certificateList.certificates)
        return VaccinationDetailViewModel(certificates: pair, repository: self.repository)
    }
    
    // MARK: - Configurations

    private func getCertficateConfiguration(for certificate: DigitalGreenCertificate) -> QRCertificateConfiguration {
        certificate.fullImmunization ? fullCertificateConfiguration(for: certificate) : halfCertificateConfiguration(for: certificate)
    }

    private func fullCertificateConfiguration(for certificate: DigitalGreenCertificate) -> QRCertificateConfiguration {
        let qrViewConfiguration = QrViewConfiguration(tintColor: .white, qrValue: NSUUID().uuidString, qrTitle: nil, qrSubtitle: nil)
        return QRCertificateConfiguration(
            title: "Covid-19 Nachweis",
            subtitle: certificate.nam.fullName,
            image: .starEmpty,
            stateImage: .completness,
            stateTitle: "Impfungen Anzeigen",
            stateAction: nil,
            headerImage: .starEmpty,
            headerAction: nil,
            backgroundColor: .onBrandAccent70,
            qrViewConfiguration: qrViewConfiguration)
    }

    private func halfCertificateConfiguration(for certificate: DigitalGreenCertificate) -> QRCertificateConfiguration {
        return QRCertificateConfiguration(
            title: "Covid-19 Nachweis",
            subtitle: certificate.nam.fullName,
            image: .starEmpty,
            stateImage: .halfShield,
            stateTitle: "Impfungen Anzeigen",
            stateAction: nil,
            headerImage: .starEmpty,
            headerAction: nil,
            backgroundColor: .onBackground50,
            qrViewConfiguration: nil)
    }
    
    private func noCertificateConfiguration() -> NoCertifiateConfiguration {
        NoCertifiateConfiguration(
            title:"vaccination_no_certificate_card_title".localized,
            subtitle: "vaccination_no_certificate_card_message".localized,
            image: .noCertificate
        )
    }
}
