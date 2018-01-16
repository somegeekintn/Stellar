//
//  Operation.swift
//  Stellar
//
//  Created by Casey Fleser on 1/14/18.
//  Copyright © 2018 Quiet Spark. All rights reserved.
//

import Foundation


// See https://raw.githubusercontent.com/stellar/js-stellar-base/master/src/generated/stellar-xdr_generated.js
//
//	xdr.struct("Operation", [
//	  ["sourceAccount", xdr.option(xdr.lookup("AccountId"))],
//	  ["body", xdr.lookup("OperationBody")],
//	]);
//
//	xdr.union("OperationBody", {
//	  switchOn: xdr.lookup("OperationType"),
//	  switchName: "type",
//	  switches: [
//		["createAccount", "createAccountOp"],
//		["payment", "paymentOp"],
//		["pathPayment", "pathPaymentOp"],
//		["manageOffer", "manageOfferOp"],
//		["createPassiveOffer", "createPassiveOfferOp"],
//		["setOption", "setOptionsOp"],
//		["changeTrust", "changeTrustOp"],
//		["allowTrust", "allowTrustOp"],
//		["accountMerge", "destination"],
//		["inflation", xdr.void()],
//		["manageDatum", "manageDataOp"],
//	  ],
//	  arms: {
//		createAccountOp: xdr.lookup("CreateAccountOp"),
//		paymentOp: xdr.lookup("PaymentOp"),
//		pathPaymentOp: xdr.lookup("PathPaymentOp"),
//		manageOfferOp: xdr.lookup("ManageOfferOp"),
//		createPassiveOfferOp: xdr.lookup("CreatePassiveOfferOp"),
//		setOptionsOp: xdr.lookup("SetOptionsOp"),
//		changeTrustOp: xdr.lookup("ChangeTrustOp"),
//		allowTrustOp: xdr.lookup("AllowTrustOp"),
//		destination: xdr.lookup("AccountId"),
//		manageDataOp: xdr.lookup("ManageDataOp"),
//	  },
//	});
//
//	xdr.enum("OperationType", {
//	  createAccount: 0,
//	  payment: 1,
//	  pathPayment: 2,
//	  manageOffer: 3,
//	  createPassiveOffer: 4,
//	  setOption: 5,
//	  changeTrust: 6,
//	  allowTrust: 7,
//	  accountMerge: 8,
//	  inflation: 9,
//	  manageDatum: 10,
//	});

class Operation: XDRDecodable, CustomStringConvertible {
	enum Body: XDRDecodable, CustomStringConvertible {
		case createAccount(_ : CreateAccountOp)
		case payment(_ : PaymentOp)
		case pathPayment
		case manageOffer(_ : ManageOfferOp)
		case createPassiveOffer
		case setOption(_ : SetOptionsOp)
		case changeTrust
		case allowTrust
		case accountMerge
		case inflation
		case manageDatum(_ : ManageDataOp)
		
		var description	: String {
			switch self {
				case .createAccount(let op):		return "createAccount: \(op)"
				case .payment(let op):				return "payment: \(op)"
				case .pathPayment:					return "pathPayment"
				case .manageOffer(let op):			return "manageOffer: \(op)"
				case .createPassiveOffer:			return "createPassiveOffer"
				case .setOption(let op):			return "setOption: \(op)"
				case .changeTrust:					return "changeTrust"
				case .allowTrust:					return "allowTrust"
				case .accountMerge:					return "accountMerge"
				case .inflation:					return "inflation"
				case .manageDatum(let op):			return "manageDatum: \(op)"
			}
		}

		init?(xdr: ExDR, capacity: Int = 1) {
			guard let rawValue = xdr.decodeEnum() else { return nil }
			
			switch rawValue {
				case 0:
					guard let op = CreateAccountOp(xdr: xdr) else { return nil }
					
					self = .createAccount(op)
				
				case 1:
					guard let op = PaymentOp(xdr: xdr) else { return nil }
					
					self = .payment(op)

				case 2:
					self = .pathPayment

				case 3:
					guard let op = ManageOfferOp(xdr: xdr) else { return nil }
					
					self = .manageOffer(op)

				case 4:
					self = .createPassiveOffer

				case 5:
					guard let op = SetOptionsOp(xdr: xdr) else { return nil }
					
					self = .setOption(op)

				case 6:
					self = .changeTrust

				case 7:
					self = .allowTrust

				case 8:
					self = .accountMerge

				case 9:
					self = .inflation

				case 10:
					guard let op = ManageDataOp(xdr: xdr) else { return nil }
					
					self = .manageDatum(op)

				default:
					return nil
			}
		}
	}
	
	let sourceAccount	: PublicKey?
	let body			: Operation.Body

	var description		: String {
		return "Operation - source: \(self.sourceAccount.map({ "\($0)" }) ?? "no source"), \(self.body)"
	}

	required init?(xdr: ExDR, capacity: Int = 1) {
		guard let accountID		= PublicKey?(xdr: xdr) else { return nil }
		guard let body			= Body(xdr: xdr) else { return nil }

		self.sourceAccount = accountID
		self.body = body
	}
}

