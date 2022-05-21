package com.qsy.settings.service.impl;

import com.qsy.settings.dao.RoleMapper;
import com.qsy.settings.dao.UserMapper;
import com.qsy.settings.pojo.Role;
import com.qsy.settings.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @author qsy
 * @create 2022/5/11 - 19:24
 */
@Service
public class RoleServiceImpl implements RoleService {
    @Autowired
    private RoleMapper roleMapper;
    @Autowired
    private  UserMapper userMapper;
    @Override
    public List<Role> queryAllRole() {
        return roleMapper.selectAllRole();
    }

    @Override
    public int addRole(Role role) {
        return roleMapper.insertRole(role);
    }

    @Override
    public void editRoleByCode(Map<String, Object> map) {
            userMapper.updateUserByRoleNo((String) map.get("code"),(String) map.get("oldCode"));
         roleMapper.updateRoleByCode(map);
    }

    @Override
    public void deleteRoleByCode(String[] code) {
        userMapper.updateRoleNoToNull(code);
         roleMapper.deleteRoleByCode(code);
    }

    @Override
    public Role queryRoleByCode(String code) {
        return roleMapper.selectRoleByCode(code);
    }

    @Override
    public List<Role> queryNotAssignedRole(String[] codes) {
        return roleMapper.selectNotAssignedRole(codes);
    }

    @Override
    public List<Role> queryAssignedRole(String[] codes) {
        return roleMapper.selectAssignedRole(codes);
    }
}
