package com.qsy.workbench.dao;

import com.qsy.workbench.pojo.Customer;

import java.util.List;

public interface CustomerMapper {
    int deleteByPrimaryKey(String id);

    int insert(Customer row);

    int insertSelective(Customer row);

    Customer selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Customer row);

    int updateByPrimaryKey(Customer row);

    //添加客户信息
    int insertCustomer(Customer customer);

    List<String> selectCustomerNameByName(String name);

    Customer selectCustomerByName(String name);
}