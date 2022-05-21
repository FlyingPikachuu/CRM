package com.qsy.settings.service;

import com.qsy.settings.pojo.Permission;

import java.util.List;

/**
 * @author qsy
 * @create 2022/5/13 - 10:28
 */
public interface PermissionService {
    //查询所有记录
    List<Permission> queryAllPermission();
    //根据Id查询指定许可
    Permission queryPermissionById(int id);

    //查询表中最大的Id
    int queryMaxId();
    //新增许可
    int addPermission(Permission permission);
    //修改许可
    int editPermissionById(Permission permission);
    int deletePermissionById(String id);
    //根据权限ids查找对应的doUrlList
    List<String> queryDoUrlListByIds(String[] ids);
    //根据权限ids查询对应的nameList
    List<String> queryNameListByIds(String[] ids);
    List<Permission> queryPermissionByIds(String[] ids);
}
