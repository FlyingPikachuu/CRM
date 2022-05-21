package com.qsy.settings.dao;

import com.qsy.settings.pojo.Permission;

import java.util.List;

public interface PermissionMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Permission row);

    int insertSelective(Permission row);

    Permission selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Permission row);

    int updateByPrimaryKey(Permission row);

    //查询所有记录
    List<Permission> selectAllPermission();
    //根据Id查询指定许可
    Permission selectPermissionById(int id);
    //查询表中最大的Id
    int selectMaxId();
    //新增许可
    int insertPermission(Permission permission);
    //修改许可
    int updatePermissionById(Permission permission);
    //删除许可
    int deletePermissionById(String id);

    //根据权限ids查找对应的doUrlList
    List<String> selectDoUrlListByIds(String[] ids);

    //根据权限ids查询对应的nameList
    List<String> selectNameListByIds(String[] ids);
    //根据ids 查询对应permissionList
    List<Permission> selectPermissionByIds(String[] ids);
}