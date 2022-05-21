package com.qsy.settings.service;

import com.qsy.settings.pojo.Dept;

import java.util.List;
import java.util.Map;

/**
 * @author qsy
 * @create 2022/5/11 - 19:23
 */
public interface DeptService {
    List<Dept> queryAllDept();

    int addDept(Dept dept);

    void editDeptByCode(Map<String,Object> map);
    void deleteDeptByCode(String[] code);
    Dept queryDeptByCode(String code);
    //根据部门名称查询指定部门
    Dept queryDeptByName(String name);
    //根据输入内容模糊查询部门名称
    List<String> queryDeptNameByName(String name);
}
