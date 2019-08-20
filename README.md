# APIClient

Библиотека предназначена для автогенерации сервисов для работы с сетью на основе аннотаций с помощью Sourcery.

Если вы как и я устали постоянно писать сервисы, то это библиотека для вас.

Библиотека использует обертку над Alamofire, но ничто не мешает использовать любую другую библиотеку для сетевого взаимодействия.


## Установка

На данный момент для установки можно воспользоваться:

### Cartage
[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate Alamofire into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
git "https://github.com/alekla/APIClient.git" ~> 1.1
```

## Использование

В первую очередь необходимо создать протокол, который будет отвечать за реализацию необходмых методов.
К нему необходимо добавить аннотацию /// sourcery: Service, иначе код имплементации не будет сгенерирован.

```swift
/// sourcery: Service
protocol UserService {

/// sourcery: path = /users/
/// sourcery: validatable, authorizationHeader = none
func fetchUsers(
    /* */       completion: @escaping APIResult<[Users])
    
/// sourcery: path = /users/{user_id}, method = post
/// sourcery: validatable, authorizationHeader = bearer
func updateUser(
    /* sourcery: path=user_id */        userId: Int,
    /* sourcery: json=name */           dataId: String,
    /* */                               completion: @escaping APIResult<Bool>)
```

Для данного протокола будет сгенерированна имплементацию, содержащая все необходимое для использования.


```swift
import Alamofire
import APIClient

class UserServiceImpl: UserService {

    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }    

    func fetchUsers(           completion: @escaping APIResult<[User]>) {
        let queryParameters: [String: Any] = [:]
        let pathParameters: [String: Any] = [:]
        let jsonParameters: [String: Any] = [:]
        let headerParameters: [String: String] = [:]
        let method: HTTPMethod = .get
        var path = "/users/"
        pathParameters.forEach { key, value in
            path = path.replacingOccurrences(
                    of: "{\(key)}",
                    with: "\(value)")
        }

        let authorizationHeader: AuthorizationHeader = .none
        let isRequestValidatable = true
        apiClient.request(path: path, queryParameters: queryParameters, jsonParameters: jsonParameters,headerParameters: headerParameters, method: method, authorizationHeader: authorizationHeader, isRequestValidatable: isRequestValidatable, completion: completion)
    }

    func updateUser(            userId: Int,                                                   dataId: String,                                                                                                           completion: @escaping APIResult<Bool>) {
        let queryParameters: [String: Any] = [:]
        let pathParameters: [String: Any] = [
            "user_id": userId
        ]
        let jsonParameters: [String: Any] = [
            "name": dataId
        ]
        let headerParameters: [String: String] = [:]
        let method: HTTPMethod = .post
        var path = "/users/{user_id}"
        pathParameters.forEach { key, value in
            path = path.replacingOccurrences(
                    of: "{\(key)}",
                    with: "\(value)")
        }
        let authorizationHeader: AuthorizationHeader = .bearer
        let isRequestValidatable = true
        apiClient.request(path: path, queryParameters: queryParameters, jsonParameters: jsonParameters,headerParameters: headerParameters, method: method, authorizationHeader: authorizationHeader, isRequestValidatable: isRequestValidatable, completion: completion)
    }
}
```

## Аннотации

Данные аннотации необходимо указывать перед телом метода:
```ogdl
/// sourcery: path = Путь на сервере
/// sourcery: method = Тип запроса(get, post)
/// sourcery: validatable если указать данный параметр, то после выполения запроса при
ответе от сервера 200 кодом completion блок будет автоматически вызываться.
/// sourcery: authorizationHeader данный парметр указывает нужно ли добавлять Authorization Header при выполении запроса.
Варианты: none, bearer, custom("Name")
```

Данные аннотации необходимо указывать перед аргументом метода:
```ogdl
/* sourcery: path=request_id */             requestId: Int,
/* sourcery: json=data_id */                dataId: String,
/* sourcery: query=root_id */               rootId: String,
/* sourcery: header=he1_header */           he1: String,
```
```
Тип path добавляет переменную внутри запроса как path
Тип query добавляет переменную внутри запроса как query
Тип json добавляет переменную внутри тела запроса как json
Тип header добавляет переменную внутри хедеров запроса 
```

