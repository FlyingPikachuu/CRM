package com.qsy.workbench.dao;

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
    int insertCustomerRemark(List<CustomerRemark> curList);
}