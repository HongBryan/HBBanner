//
//  HKBaseDBTableModel.swift
//  HKAtHome
//
//  Created by Bryan on 2021/6/7.
//  Copyright © 2021 HomeKing. All rights reserved.
//
//  说明:说有数据库模型都要基于该基类来写,统一类操作

import Foundation
import WCDBSwift

//MARK: - 数据库表基础模型
public protocol KBBaseDBTableModel: TableCodable, HKBaseJSONModel {
    static func tableName() -> String       //表名称,必填
    static func primaryKeys() -> [String]?  //主键
}

extension KBBaseDBTableModel {
//    static func primaryKeys() -> [String]? {
//        return nil
//    }
}

//MARK: - 数据库基础模型
class KBDatabaseModel {
//    let dataBasePath = URL(fileURLWithPath: HMDataBasePath().dbPath)
    public var wcdb: Database?
    //MARK: - Cycle Life
    init(filePath: String!) {
//        dataBase = Database(withFileURL: URL(fileURLWithPath: filePath))
        wcdb = Database(withPath: filePath)
    }
    
    deinit {
        wcdb?.close()
    }
}

extension HKDatabaseModel {
    //MARK: - Public Methods
    public func createTable<Root: HKBaseDBTableModel>(rootType: Root.Type) {
        let tblName = rootType.tableName()
        do {
            try wcdb?.create(table: tblName, of: rootType.self)
        } catch {
            print("createTable:",error)
        }
    }
    
    public func insert<HKTable: HKBaseDBTableModel>(tblModel: HKTable) {
        let tblName = HKTable.tableName()
        do {
            try wcdb?.insert(objects: tblModel, intoTable: tblName)
        } catch  {
            print("insert:",error)
        }
    }
    
    //MARK: - 依赖于主键进行查询
    public func select<HKTable: HKBaseDBTableModel>(tblModel: HKTable?) -> HKTable? {
        let tables = selects(tblModel: tblModel, isPrimaryLimit: true)
        guard let selectModel = tables?.first else {
            return nil
        }
        return selectModel
//        return tables?.first
    }
    
    //MARK: - 根据tblModel中有赋值的字段进行查询
    public func selects<HKTable: HKBaseDBTableModel>(tblModel: HKTable?) -> [HKTable]? {
        return selects(tblModel: tblModel, isPrimaryLimit: false)
    }
    
    //MARK: - 根据tblModel中有赋值的字段进行查询
    private func selects<HKTable: HKBaseDBTableModel>(tblModel: HKTable?, isPrimaryLimit: Bool) -> [HKTable]? {
        guard let hkwcdb = wcdb else {
            return nil
        }
        guard let dict = tblModel?.toDict() else {
            return nil
        }
        let tblName = HKTable.tableName()
        let primarys = HKTable.primaryKeys()
        var conditions = [String]()
        var selectSql = "select * from " + tblName + " where "
        var values = [String]()
        for (key, value) in dict {
            if isPrimaryLimit == true,primarys?.contains(key) == false {
                continue
            }
            let string = key + "= ?"
            var val: String?
            if type(of: value) == Int.self {
                let valueInt: Int = value as! Int
                val = String(valueInt)
            } else if type(of: value) == String.self {
                val = value as? String
            } else {
                continue
            }
            values.hk_append(val)
            conditions.hk_append(string)
        }
        selectSql.append(conditions.joined(separator: " and "))
        var tables: [HKTable]?
        do {
            let hkSql = try hkwcdb.prepareSelectSQL(on: HKTable.CodingKeys.all, sql: selectSql, values: values)
            tables = try hkSql.allObjects()
        } catch {
            print("查询失败:",error)
        }
        print("查询内容:",tables)
        return tables
    }
    
    //MARK: - 针对主键删除,会单独把主键拿出来对比删除
    public func delete<HKTable: HKBaseDBTableModel>(tblModel: HKTable?) -> Bool {
        var isSuccess = true
        guard let dict = tblModel?.toDict() else {
            return false
        }
        
        let tblName = HKTable.tableName()
        let primarys = HKTable.primaryKeys()
        var conditions = [String]()
//        for (key, value) in dict {
//            if primarys?.contains(key) == false {
//                continue
//            }
//            var string: String?
//            if type(of: value) == Int.self {
//                let valueInt: Int = value as! Int
//                string = key + "=" + String(valueInt)
//            } else {
//                let valueString: String = value as! String
//                string = key + "=" + valueString
//            }
//            conditions.hk_append(string)
//        }
        var values = [String]()
        for (key, value) in dict {
            if primarys?.contains(key) == false {
                continue
            }
            let string = key + "= ?"
            var val: String?
            if type(of: value) == Int.self {
                let valueInt: Int = value as! Int
                val = String(valueInt)
            } else if type(of: value) == String.self {
                val = value as? String
            } else {
                continue
            }
            values.hk_append(val)
            conditions.hk_append(string)
        }
        let deleteSql = "delete from " + tblName + " where " + conditions.joined(separator: " and ")
        do {
//            try wcdb?.prepareUpdateSQL(sql: deleteSql).execute()
            try wcdb?.prepareUpdateSQL(sql: deleteSql, values: values).execute()
        } catch {
            print("删除失败:",error)
            isSuccess = false
        }
        return isSuccess
    }
    
    //MARK: - 根据tblModel中有赋值的字段进行删除
    public func deletes<HKTable: HKBaseDBTableModel>(tblModel: HKTable?) -> Bool {
        return deletes(tblModel: tblModel, isPrimaryLimit: false)
    }
    
    private func deletes<HKTable: HKBaseDBTableModel>(tblModel: HKTable?, isPrimaryLimit: Bool) -> Bool {
        var isSuccess = true
        guard let dict = tblModel?.toDict() else {
            return false
        }
        
        let tblName = HKTable.tableName()
        let primarys = HKTable.primaryKeys()
        var conditions = [String]()
//        for (key, value) in dict {
//            if isPrimaryLimit == true, primarys?.contains(key) == false {
//                continue
//            }
//            var string: String?
//            if type(of: value) == Int.self {
//                let valueInt: Int = value as! Int
//                string = key + "=" + String(valueInt)
//            } else {
//                let valueString: String = value as! String
//                string = key + "=" + valueString
//            }
//            conditions.hk_append(string)
//        }
        
        var values = [String]()
        for (key, value) in dict {
            if isPrimaryLimit == true, primarys?.contains(key) == false {
                continue
            }
            let string = key + "= ?"
            var val: String?
            if type(of: value) == Int.self {
                let valueInt: Int = value as! Int
                val = String(valueInt)
            } else if type(of: value) == String.self {
                val = value as? String
            } else {
                continue
            }
            values.hk_append(val)
            conditions.hk_append(string)
        }
        
        let deleteSql = "delete from " + tblName + " where " + conditions.joined(separator: " and ")
        do {
            try wcdb?.prepareUpdateSQL(sql: deleteSql, values: values).execute()
        } catch {
            print("删除失败:",error)
            isSuccess = false
        }
        return isSuccess
    }
    
    public func forceInsert<HKTable: HKBaseDBTableModel>(tblModel: HKTable) -> Bool {
        var isSuccess = true
        _ = delete(tblModel: tblModel)
        do {
            try wcdb?.insert(objects: tblModel, intoTable: HKTable.tableName())
        } catch  {
            print("insert:",error)
            isSuccess = false
        }
        return isSuccess
    }
    
    //MARK: - 删除某个表所有数据
    public func delete<Root: HKBaseDBTableModel>(rootType: Root.Type) -> Bool {
        var isSuccess: Bool = true
        let tblName = rootType.tableName()
        do {
            try wcdb?.delete(fromTable: tblName)
            
        } catch {
            print("delete:",error)
            isSuccess = false
        }
        return isSuccess
    }
    
    //MARK: - 只传类,把表中所有的数据全部查找出来
    public func select<Root: HKBaseDBTableModel>(rootType: Root.Type) -> [Root]? {
        let tblName = rootType.tableName()
        var objects: [Root]?
        do {
            objects = try wcdb?.getObjects(fromTable: tblName)
        } catch  {
            print("select error:",error)
        }
        return objects
    }
    
    /// 开启数据库事务
    public func beginTransaction() {
        do {
            try wcdb?.getTransaction().begin()
        } catch {
            print("beginTransaction:",error)
        }
    }
    
    /// 提交数据库事务
    public func commitTransaction() {
        do {
            try wcdb?.getTransaction().commit()
        } catch {
            print("beginTransaction:",error)
        }
    }
    
    public func close() {
        wcdb?.close()
    }
}

