//
//  File.swift
//  
//
//  Created by Alex Young on 3/26/22.
//

import XCTest
@testable import XeroIntegration
import UnixIntegrationTools
import NetworkRequestTools
import Foundation
import XeroDecoder




extension XeroIntegrationTests {


    
    func testBalanceSheet() {
        
        struct Tenant {
            var ID : String
            var name : String
        }
        
        let startDate = "2021-01-01"
        let endDate = "2021-10-31"
        var tenants : [Tenant] = []
        tenants.append(Tenant(ID:"ef8db4d4-deed-4637-bbfe-700ccb60e302", name: "Lieberose"))
        tenants.append(Tenant(ID:"25e403da-135e-49ef-ade2-538e9a729fd3", name: "Personal"))
        tenants.append(Tenant(ID:"e380c68a-8415-4817-bcf6-1c78d493c650", name: "Chomtong"))
        tenants.append(Tenant(ID:"fbb1e335-460a-4fd3-9ff2-2aede68d95fc", name: "OWPG"))
        
        
        let file = UnixFile(at: "/Users/alexyoung/swift/CashAccounts/", named: "XeroCashAccounts.csv")
        file.delete()
        file.write("Account ID, Account Name, Balance, Company Name\r")
        
        for tenant in tenants {
            
            let semaphore = DispatchSemaphore (value: 0)
            let request = BankAccountRequest<XeroToken>(tenantID: tenant.ID, startDate: startDate, endDate: endDate)
            request.executeRequest(using: request.requestContent()) { data, response, error -> Void in
                guard let data = data
                else {
                    print("Error!")
                    print(String(describing: error))
                    semaphore.signal()
                    return
                }
                if let dataString = String(data: data, encoding: .utf8) {
                print("The API returned the following data: \(dataString))")
                XCTAssertEqual(true, true)
                
                let resultArray = XeroBankAccountsDecoder.decodeCashAccounts(with: data)
                print(resultArray)
                for result in resultArray {
                    file.write("\(result.ID), \(result.name), \(result.balance), \(tenant.name)\r")
                                    }
                    semaphore.signal()
                }
            }

            semaphore.wait()
        }
    }

    
    
}
