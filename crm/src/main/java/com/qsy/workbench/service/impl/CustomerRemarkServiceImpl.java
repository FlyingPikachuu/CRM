package com.qsy.workbench.service.impl;

import com.qsy.workbench.dao.CustomerRemarkMapper;
import com.qsy.workbench.pojo.CustomerRemark;
import com.qsy.workbench.service.CustomerRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author qsy
 * @create 2022/5/8 - 8:29
 */
@Service
public class CustomerRemarkServiceImpl implements CustomerRemarkService {
    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;
    @Override
    public List<CustomerRemark> queryCustomerRemarkForDetailByCustomerId(String customerId) {
        return customerRemarkMapper.selectCustomerRemarkForDetailByCustomerId(customerId);
    }

    @Override
    public int addCustomerRemark(CustomerRemark customerRemark) {
        return customerRemarkMapper.insertCustomerRemark(customerRemark);
    }

    @Override
    public int deleteCustomerRemarkById(String id) {
        return customerRemarkMapper.deleteCustomerRemarkById(id);
    }

    @Override
    public int editCustomerRemark(CustomerRemark customerRemark) {
        return customerRemarkMapper.updateCustomerRemark(customerRemark);
    }
}
