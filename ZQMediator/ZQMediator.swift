//
//  ZQMediator.swift
//  ZQMediator
//
//  Created by 周强 on 2018/7/4.
//  Copyright © 2018年 周强. All rights reserved.
//

import UIKit

/// 组件化协调类
open class ZQMediator: NSObject {
    public static let `default`: ZQMediator = ZQMediator()
    private var cachedTarget: [String: NSObject] = [String: NSObject]()
    private override init() {
        super.init()
    }
}

extension ZQMediator {
    /// 动态调用方法
    ///
    /// - Parameters:
    ///   - space: 模块名称
    ///   - targetName:  Target 的后半部分名称, Target_Trends: Trends
    ///   - actionName: Action_xXXXX: xXXXXX
    ///   - params: 字典
    ///   - shouldCacheTarget:  是否缓存对象
    /// - Returns: 返回成功或者失败, 或者返回对象, 或者 nil
    public func perform(nameSpace space: String, target targetName: String, action actionName: String, params: [String: Any]?, shouldCacheTarget: Bool = false) -> AnyObject? {
        
        print(space)
        print(targetName)
        print(actionName)
        
        var targetObj: NSObject?
        var targetClass: NSObject.Type?
        let classString = "\(space).\(targetName)"
        
        if shouldCacheTarget {
            targetObj = cachedTarget[classString]
        }
        
        if targetObj == nil {
            targetClass = NSClassFromString(classString) as? NSObject.Type
            guard let targetType = targetClass else {
                return nil
            }
            targetObj = targetType.init()
            if shouldCacheTarget, targetObj != nil {
                cachedTarget[classString] = targetObj!
            }
        }
        
        let actionSelector = NSSelectorFromString("\(actionName)")
        
        guard targetObj != nil, targetObj!.responds(to: actionSelector) else {
            return nil
        }
        
        let result = targetObj?.perform(actionSelector, with: params)
        
        return result?.takeUnretainedValue();
    }
}
