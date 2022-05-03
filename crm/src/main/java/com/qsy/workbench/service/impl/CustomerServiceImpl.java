package com.qsy.workbench.service.impl;

import com.qsy.workbench.dao.CustomerMapper;
import com.qsy.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author qsy
 * @create 2022/5/3 - 9:20
 */
@Service
public class CustomerServiceImpl implements CustomerService {
    @Autowired
    private CustomerMapper customerMapper;
    @Override
    public List<String> queryCustomerNameByName(String name) {
        return  customerMapper.selectCustomerNameByName(name);
    }
}
