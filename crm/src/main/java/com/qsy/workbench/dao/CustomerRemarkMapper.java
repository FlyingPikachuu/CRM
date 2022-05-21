package com.qsy.workbench.dao;

import com.qsy.workbench.pojo.CustomerRemark;
import com.qsy.workbench.pojo.CustomerRemark;

import java.util.List;

public interface CustomerRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insert(CustomerRemark row);

    int insertSelective(CustomerRemark row);

    CustomerRemark selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(CustomerRemark row);

    int updateByPrimaryKey(CustomerRemark row);

    //转换中，批量转换客户备注
    int insertCustomerRemarkByList(List<CustomerRemark> curList);

    //查询所有备注
    List<CustomerRemark> selectCustomerRemarkForDetailByCustomerId(String customerId);

    //添加一条备注
    int insertCustomerRemark(CustomerRemark customerRemark);

    //删除一条备注
    int deleteCustomerRemarkById(String id);

    //修改一条备注
    int updateCustomerRemark(CustomerRemark customerRemark);

    //根据customerId删除备注
    int deleteCustomerRemarkByCustomerId(String[] customerId);
}