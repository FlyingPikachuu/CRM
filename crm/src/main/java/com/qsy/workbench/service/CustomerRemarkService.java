package com.qsy.workbench.service;

import com.qsy.workbench.pojo.CustomerRemark;

import java.util.List;

/**
 * @author qsy
 * @create 2022/5/8 - 8:29
 */
public interface CustomerRemarkService {
    List<CustomerRemark> queryCustomerRemarkForDetailByCustomerId(String customerId);

    //添加一条备注
    int addCustomerRemark(CustomerRemark customerRemark);

    //删除一条备注
    int deleteCustomerRemarkById(String id);

    //修改一条备注
    int editCustomerRemark(CustomerRemark customerRemark);
}
