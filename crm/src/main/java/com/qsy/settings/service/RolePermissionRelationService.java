package com.qsy.settings.service;

import com.qsy.settings.pojo.RolePermissionRelation;

import java.util.List;

/**
 * @author qsy
 * @create 2022/5/13 - 22:14
 */
public interface RolePermissionRelationService {
    String queryPidByRoleId(String roleId);

    void assignPermission(RolePermissionRelation rolePermissionRelation);

    List<String> queryPidByRoleIds(String[] roleIds);

}
