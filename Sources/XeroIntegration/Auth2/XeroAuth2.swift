import NetworkRequestTools
import Foundation


//public struct QuickbooksToken : Codable {
//    public var x_refresh_token_expires_in: Int
//    public var access_token: String
//    public var refresh_token: String
//    public var token_type: String
//    public var expires_in: Int
//}

public struct XeroTokenStruct : Codable {
    public var id_token: String
    public var access_token: String
    public var expires_in: Int
    public var token_type: String
    public var refresh_token: String
    public var scope : String
}

public class XeroToken: TokenRequestParticulars {
    
    public static var entityName = "Xero All Tenants" // replace with entity name
    public static var tokenDirectory = "/Users/alexyoung/swift/XeroIntegration/Tokens/" // replace with token file name
    public static var entityID = "XeroAllTenants" // replace with entity ID
    public static var tokenFileName : String {entityID + ".json"}
    public static var token: APItoken?
    public static var xeroToken : XeroTokenStruct?
    
    // 3. Implement storeToken to decode the token and store its values in the static variables for the class.
    public static func storeToken(_ data:Data) -> Bool {
        var didSucceed = false
        do{ // replace the elements of codedToken with the correct labels from the token struct in (1)
            let xeroToken = try JSONDecoder().decode(XeroTokenStruct.self, from: data)
            self.xeroToken = xeroToken
            XeroToken.token = APItoken(access: xeroToken.access_token, refresh: xeroToken.refresh_token, expiry: xeroToken.expires_in) // add the expiry to the current time in seconds since 1970 to get the percise expiry
            didSucceed = true
        }
        catch {
            print("could not decode token on file")
            didSucceed = false
        }
        return didSucceed
    }
    //4. Implement outputToken which takes the token saved in the coded token struct object modeled in (1) and then returns a JSON string. The standard class methods will convert the JSON string to data and save it to the file. The code below should not need to be changed except for the name of the coded Token class.
    public static func outputToken() -> String {
        var jsonString = ""
        do {
            let encodedData = try JSONEncoder().encode(XeroToken.xeroToken)
            jsonString = String(data: encodedData, encoding: .utf8)!
        }
        catch {
            print("could not encode token in memory")
        }
        return jsonString
    }
}

