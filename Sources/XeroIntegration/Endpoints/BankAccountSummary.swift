//
//  BankAccountSummary.swift
//  
//
//  Created by Alex Young on 3/26/22.
//

import Foundation

import Foundation
import NetworkRequestTools

open class BankAccountRequest<Client : TokenRequestParticulars> : NetworkRequest {
    
    public var tenantID: String
    
    
    open override var headers: [String : String]? {
               
        get {

            let tokenRequest = TokenRequest<Client>(url: "https://identity.xero.com/connect/token", httpMethod: .POST)
           
            let client_id = "C522836310234A1E835C10896629AD12"
            let client_secret = "0-M4SXhIkN0_bmDi05HKcvwLktZJxCjAlrt0P2h5tzzyBTI4"
            let authString = client_id + ":" + client_secret
            let authString64 = authString.toBase64()
            let authorization = "Basic " + authString64
            let headers = ["Authorization" : authorization ]
            tokenRequest.headers = headers
            if !tokenRequest.loadToken() {
                print("The loadToken method failed")
            }
            
   
            guard let tokenClient = Client.token  else {
                    print("There was no token loaded to memory")
                    return nil
                }
                let accessToken = tokenClient.access
            return [ "authorization": "Bearer \(accessToken)", "Accept" : "application/json", "xero-tenant-id" : tenantID]
        }
        
        set {
                    super.headers = newValue
                }
    }
    
    
   public init(tenantID: String, startDate:String, endDate:String) {
        
       
        self.tenantID = tenantID
        
        let endpointURL  = "https://api.xero.com/api.xro/2.0/Reports/BankSummary?fromDate=\(startDate)&toDate=\(endDate)"
        super.init(url: endpointURL, httpMethod: .GET)
        

    }
    
}
