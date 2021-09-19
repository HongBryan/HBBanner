//
//  HKBaseJSONModel.swift
//  HKAtHome
//
//  Created by Bryan on 2021/6/7.
//  Copyright © 2021 HomeKing. All rights reserved.
//
//  说明:所有的JSON模型都必须要继承到该类

import UIKit
import HandyJSON
import SwiftyJSON

public protocol KBBaseJSONModel: HandyJSON {
    //MARK: - Property
}

extension KBBaseJSONModel{
//    init() {
//        self.init()
//    }
    /// 字典初始化对象
    /// - Parameter jsonDict: 字典
    init(jsonDict: [String: Any]?) {
        self.init()
        if jsonDict == nil {
            return
        }
        JSONDeserializer.update(object: &self, from: jsonDict)
    }
    
    
    /// JSON字符串初始化对象
    /// - Parameter jsonString: JSON字符串
    init(jsonString: String?) {
        self.init()
        if jsonString == nil {
            return
        }
        JSONDeserializer.update(object: &self, from: jsonString)
    }
    
    /// JSON二进制初始化对象
    /// - Parameter jsonData: JSON二进制数据
    init(jsonData: Data?) {
        self.init()
        if jsonData == nil {
            return
        }
        let jsonString = String.init(data: jsonData!, encoding: .utf8)
        JSONDeserializer.update(object: &self, from: jsonString)
    }
    
    /// JSON文件转化成模型
    /// - Parameter filePath: 文件路径
    init(filePath: String?) {
        self.init()
        if filePath == nil {
            return
        }
        guard let jsonFileURL = URL(string: filePath!) else {
            print("文件路劲转换失败")
            return
        }
        let jsonString = try! String(contentsOf: jsonFileURL)
        JSONDeserializer.update(object: &self, from: jsonString)
    }
    
    /// 字典初始化对象
    /// - Parameter jsonDict: 字典
    init(json: JSON?) {
        self.init()
        if json == nil {
            return
        }
        JSONDeserializer.update(object: &self, from: json?.rawString())
    }
    
    public static func modelWith(json: JSON?) ->Self? {
        if json == nil {
            return nil
        }
        let model = Self.init(json: json)
        return model
    }
    
    /// 暂时可不用
    /// - Parameter dict:
    /// - Returns:
    public static func modelFrom<T>(dict: [String: Any]?) -> T? where T : KBBaseJSONModel{
        if dict == nil {
            return nil
        }
        return JSONDeserializer<T>.deserializeFrom(dict: dict)
    }
    
    public static func modelArray(json: JSON?) -> [Self]? {
        guard let jsonArray = json?.arrayValue else {
            return nil
        }
        var modelArray = [Self]()
        for jsonItem in jsonArray {
            let model = Self.init(json: jsonItem)//T(json: jsonItem)
            modelArray.append(model)
        }
        return modelArray
    }
    
    /// 各种对象转JSON
    /// - Parameter jsonAny: 任意对象,目前只支持几种
    init(jsonAny: Any) {
        self.init()
        if jsonAny is [String: Any] {
            JSONDeserializer.update(object: &self, from: jsonAny as? [String: Any])
        }else if jsonAny is String {
            JSONDeserializer.update(object: &self, from: jsonAny as? String)
        }else if jsonAny is Data {
            let jsonString = String.init(data: jsonAny as! Data, encoding: .utf8)
            JSONDeserializer.update(object: &self, from: jsonString)
        }else if jsonAny is JSON {
            let json = jsonAny as? JSON
            JSONDeserializer.update(object: &self, from: json?.dictionaryObject)
        }else if jsonAny is KBBaseJSONModel {
            let model = jsonAny as? KBBaseJSONModel
            JSONDeserializer.update(object: &self, from: model?.toDict())
        }
    }
    
    public func generateModel(jsonAny: Any) -> KBBaseJSONModel? {
        return Self(jsonAny: jsonAny)
    }
    
    /// 模型转字典
    /// - Returns: 字典
    public func toDict() -> [String: Any]? {
        return toJSON()
    }
    
    /// 模型转字符串
    /// - Returns: JSON格式的字符串
    public func toString() -> String? {
        return toJSONString()
    }
    
    /// 模型转换成二进制
    /// - Returns: 二进制
    public func toData() -> Data? {
        let jsonString = toString()
        return jsonString?.data(using: .utf8)
    }
}
