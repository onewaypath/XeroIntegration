import XCTest
@testable import XeroIntegration
import UnixIntegrationTools
import NetworkRequestTools

final class XeroIntegrationTests: XCTestCase {
    
       
        func testReadTokenOWPLS() {
            
            let tokenRequest = TokenRequest<XeroToken>(url: "https://identity.xero.com/connect/token", httpMethod: .GET)
            //XCTAssertEqual(true,  tokenRequest.readToken())
            XCTAssertEqual(true,  tokenRequest.readToken())
            guard let quickbooksToken = XeroToken.xeroToken else {
                print ("Token was not loaded to memory")
                XCTAssertEqual(true, false)
                return
                
            }
            
            XCTAssertEqual(quickbooksToken.expires_in, 1800)
            
            guard let token = XeroToken.token else {
                print("The token was decoded but could not be loaded")
                return
            }
            
            
            XCTAssertEqual(token.expiry, token.expiry) // just confirming that the function did not return because OWPMRtoken.token is nil
            
            
        }
        
        // Read the exisiting refresh token into memory and then use it to execute the getToken method which retrieves a new token from the API. Write the new token to the file and then use readToken to check that access token written to file is the same one that was received from the API.
        func testGetWriteTokenOWPLS() {
            
            let tokenRequest = TokenRequest<XeroToken>(url: "https://identity.xero.com/connect/token", httpMethod: .POST)
            
            //tokenRequest.loadToken()
            //XCTAssertEqual(true,  tokenRequest.readToken())
            XCTAssertEqual(true,  tokenRequest.readToken())

            let client_id = "C522836310234A1E835C10896629AD12"
            let client_secret = "0-M4SXhIkN0_bmDi05HKcvwLktZJxCjAlrt0P2h5tzzyBTI4"
            let authString = client_id + ":" + client_secret
            let authString64 = authString.toBase64()
            let authorization = "Basic " + authString64
            
            let headers = ["Authorization" : authorization ]
                    
            guard let token = XeroToken.token else {
                print("Could not load refresh token")
                return
            }
            print("sending API request using refresh token: \(token.refresh)")
            
            tokenRequest.headers = headers
            
            
            XCTAssertEqual(true, tokenRequest.getToken())
            guard let token2 = XeroToken.token else {
                print("Could not load refresh token")
                return
            }
            
            let testAccessToken = token2.access
    
            
            tokenRequest.writeToken()
            //XCTAssertEqual(true,  tokenRequest.readToken())
            XCTAssertEqual(true,  tokenRequest.readToken())
            guard let token3 = XeroToken.token else {
                print("Could not load access token")
                return
            }
            XCTAssertEqual(testAccessToken, token3.access)
            
        }
        
        // the loadToken returns true if a valid token either exists or can be loaded to memory. Therefore, only the return value of loadToken needs to be checked to make sure it is working properly.
        func testLoadTokenOWPLS() {
            let tokenRequest = TokenRequest<XeroToken>(url: "https://identity.xero.com/connect/token", httpMethod: .POST)
            //XCTAssertEqual(true,  tokenRequest.readToken())
            XCTAssertEqual(true,  tokenRequest.readToken())
            let client_id = "C522836310234A1E835C10896629AD12"
            let client_secret = "0-M4SXhIkN0_bmDi05HKcvwLktZJxCjAlrt0P2h5tzzyBTI4"
            let authString = client_id + ":" + client_secret
            let authString64 = authString.toBase64()
            let authorization = "Basic " + authString64
            
            let headers = ["Authorization" : authorization ]
            tokenRequest.headers = headers
            XCTAssertEqual(true,  tokenRequest.loadToken())
            
        }
        
        func testTokenIsValidOWPLS() {
            
            let tokenRequest = TokenRequest<XeroToken>(url: "https://identity.xero.com/connect/token", httpMethod: .POST)
            
            //tokenRequest.loadToken()
            //XCTAssertEqual(true,  tokenRequest.readToken())
            XCTAssertEqual(true,  tokenRequest.readToken())
            let client_id = "C522836310234A1E835C10896629AD12"
            let client_secret = "0-M4SXhIkN0_bmDi05HKcvwLktZJxCjAlrt0P2h5tzzyBTI4"
            let authString = client_id + ":" + client_secret
            let authString64 = authString.toBase64()
            let authorization = "Basic " + authString64
            
            let headers = ["Authorization" : authorization ]
            
            guard let token = XeroToken.token else {
                print("Could not load refresh token")
                return
            }
            print("sending API request using refresh token: \(token.refresh)")
            
            tokenRequest.headers = headers
            
            
            XCTAssertEqual(true, tokenRequest.getToken())
    
            guard let token2 = XeroToken.token else {
                print("Could not load refresh token")
                return
            }
            let testAccessToken = token2.access
            // write a new token to a file and confirm that the access token written to the file is the same as the one that was retrieved from the API
            
            tokenRequest.writeToken()
            //XCTAssertEqual(true,  tokenRequest.readToken())
            XCTAssertEqual(true,  tokenRequest.readToken())
            XCTAssertEqual(testAccessToken, XeroToken.token?.access)
            
            // change the expiry of the access token in memory to the time now and then after a 2 second delay, check whether the token is still valid (it should not be)
            
            
            
            XeroToken.token?.expiry = 1
            do { sleep(2) }
            XCTAssertEqual(false, tokenRequest.tokenIsValid())
            
            // reset the token exipry to the standard 3600 seconds and then check the validity again. This time the it should be valid since the token was retrieved from the API only a few seconds prior
            
            XeroToken.token?.expiry = 1800
            do { sleep(2) }
            XCTAssertEqual(true, tokenRequest.tokenIsValid())
            
        }
        
    
    
}



