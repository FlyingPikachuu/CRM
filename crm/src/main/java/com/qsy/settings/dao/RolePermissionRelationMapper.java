package com.qsy.settings.dao;

import com.qsy.settings.pojo.RolePermissionRelation;

import java.util.List;

public interface RolePermissionRelationMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(RolePermissionRelation row);

    int insertSelective(RolePermissionRelation row);

    RolePermissionRelation selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(RolePermissionRelation row);

    int updateByPrimaryKey(RolePermissionRelation row);

    //根据roleId查询PermissionId
    String selectPidByRoleId(String roleId);
    //根据roleIds查询PermissionId
    List<String> selectPidByRoleIds(String[] roleIds);
    //根据roleId查询RPR
    RolePermissionRelation selectRPRByRoleId(String roleId);
    //添加一条关系记录
    int insertRPR(RolePermissionRelation rolePermissionRelation);
    //修改一条关系记录
    int updateRPRByRoleId(RolePermissionRelation rolePermissionRelation);
}