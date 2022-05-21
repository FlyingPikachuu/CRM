package com.qsy.settings.service;

import com.qsy.settings.pojo.Role;

import java.util.List;
import java.util.Map;

/**
 * @author qsy
 * @create 2022/5/11 - 19:23
 */
public interface RoleService {
    List<Role> queryAllRole();

    int addRole(Role role);

    void editRoleByCode(Map<String,Object> map);
    void deleteRoleByCode(String[] code);
    Role queryRoleByCode(String code);

    List<Role> queryNotAssignedRole(String[] codes);

    List<Role> queryAssignedRole(String[] codes);


}
