package com.qsy.settings.service.impl;

import com.qsy.settings.dao.DeptMapper;
import com.qsy.settings.dao.UserMapper;
import com.qsy.settings.pojo.Dept;
import com.qsy.settings.service.DeptService;
import com.qsy.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @author qsy
 * @create 2022/5/11 - 19:23
 */
@Service
public class DeptServiceImpl implements DeptService {
    @Autowired
    private DeptMapper deptMapper;
    @Autowired
    private UserMapper userMapper;
    @Override
    public List<Dept> queryAllDept() {
        return deptMapper.selectAllDept();
    }

    @Override
    public int addDept(Dept dept) {
        return deptMapper.insertDept(dept);
    }

    @Override
    public void editDeptByCode(Map<String, Object> map) {
        if((String)map.get("code")!=(String)map.get("oldCode")){
            userMapper.updateUserDeptNoByCode((String)map.get("code"),(String)map.get("oldCode"));
        }
        deptMapper.updateDeptByCode(map);

    }

    @Override
    public void deleteDeptByCode(String[] code) {
        userMapper.deleteUserByDeptNO(code);
        deptMapper.deleteDeptByCode(code);
    }

    @Override
    public Dept queryDeptByCode(String code) {
        return deptMapper.selectDeptByCode(code);
    }

    @Override
    public Dept queryDeptByName(String name) {
        return deptMapper.selectDeptByName(name);
    }

    @Override
    public List<String> queryDeptNameByName(String name) {
        return deptMapper.selectDeptNameByName(name);
    }
}
