package com.qsy.settings.service.impl;

import com.qsy.settings.dao.PermissionMapper;
import com.qsy.settings.pojo.Permission;
import com.qsy.settings.service.PermissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author qsy
 * @create 2022/5/13 - 10:28
 */
@Service
public class PermissionServiceImpl implements PermissionService {
    @Autowired
    private PermissionMapper permissionMapper;
    @Override
    public List<Permission> queryAllPermission() {
        return permissionMapper.selectAllPermission();
    }

    @Override
    public Permission queryPermissionById(int id) {
        return permissionMapper.selectPermissionById(id);
    }

    @Override
    public int queryMaxId() {
        return permissionMapper.selectMaxId();
    }

    @Override
    public int addPermission(Permission permission) {
        return permissionMapper.insertPermission(permission);
    }

    @Override
    public int editPermissionById(Permission permission) {
        return permissionMapper.updatePermissionById(permission);
    }

    @Override
    public int deletePermissionById(String id) {
        return permissionMapper.deletePermissionById(id);
    }

    @Override
    public List<String> queryDoUrlListByIds(String[] ids) {
        return permissionMapper.selectDoUrlListByIds(ids);
    }

    @Override
    public List<String> queryNameListByIds(String[] ids) {
        return permissionMapper.selectNameListByIds(ids);
    }

    @Override
    public List<Permission> queryPermissionByIds(String[] ids) {
        return permissionMapper.selectPermissionByIds(ids);
    }
}
