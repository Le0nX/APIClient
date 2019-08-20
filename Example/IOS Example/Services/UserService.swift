import APIClient

/// sourcery: Service
protocol UserService {
    
    /// sourcery: path = /data, method = get
    /// sourcery: validatable, authorizationHeader = auth
    func fetchData(
    /* */                                       completion: @escaping APIResult<Bool>)
    
    /// sourcery: path = /data, method = get
    /// sourcery: validatable, authorizationHeader = none
    func fetchDataNoHeader(
    /* */                                       completion: @escaping APIResult<Bool>)

    
    /// sourcery: path = /users, method = post
    /// sourcery: validatable, authorizationHeader = custom("Rule")
    func fetchUsers(
    /* sourcery: path=request_id */             requestId: Int,
    /* sourcery: json=data_id */                dataId: String,
    /* sourcery: query=root_id */               rootId: String,
    /* sourcery: header=he1_header */           he1: String,
    /* */                                       completion: @escaping APIResult<Bool>)

}
