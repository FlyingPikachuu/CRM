package com.qsy.workbench.service.impl;

import com.qsy.workbench.dao.ContactMapper;
import com.qsy.workbench.dao.CustomerMapper;
import com.qsy.workbench.dao.CustomerRemarkMapper;
import com.qsy.workbench.dao.TransactionMapper;
import com.qsy.workbench.pojo.Customer;
import com.qsy.workbench.pojo.FunnelVO;
import com.qsy.workbench.pojo.LBVO;
import com.qsy.workbench.pojo.PieVO;
import com.qsy.workbench.service.CustomerService;
import com.qsy.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @author qsy
 * @create 2022/5/3 - 9:20
 */
@Service
public class CustomerServiceImpl implements CustomerService {
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;
    @Autowired
    private TransactionMapper transactionMapper;
    @Autowired
    private ContactMapper contactMapper;
    @Override
    public List<String> queryCustomerNameByName(String name) {
        return  customerMapper.selectCustomerNameByName(name);
    }

    @Override
    public int addCustomer(Customer customer) {
        return  customerMapper.insertCustomer(customer);
    }

    @Override
    public List<Customer> queryCustomerByConditionForPage(Map<String, Object> map) {
        return customerMapper.selectCustomerByConditionForPage(map);
    }

    @Override
    public int queryCountOfCustomerByCondition(Map<String, Object> map) {
        return customerMapper.selectCountOfCustomerByCondition(map);
    }

    @Override
    public Customer queryCustomerById(String id) {
        return customerMapper.selectCustomerById(id);
    }

    @Override
    public int editCustomerById(Customer customer) {
        return customerMapper.updateCustomerById(customer);
    }

    @Override
    public void deleteCustomer(String[] ids) {
        //新建客户公海记录=客户信息+客户第一联系人
        //将客户备注和联系人备注添加到客户公海备注详情中

        //删除备注信息
        customerRemarkMapper.deleteCustomerRemarkByCustomerId(ids);
        //删除交易信息
        transactionMapper.deleteTransactionByCustomerId(ids);
        //删除联系人信息
        contactMapper.deleteContactByCustomerId(ids);
        //删除客户信息
        customerMapper.deleteCustomerByIds(ids);
    }

    @Override
    public Customer queryCustomerByIdForDetail(String id) {
        return customerMapper.selectCustomerByIdForDetail(id);
    }

    @Override
    public List<FunnelVO> queryCountOfCustomerByCutAddress() {
        return customerMapper.selectCountOfCustomerByCutAddress();
    }

    @Override
    public List<LBVO> queryCountOfCustomerByOwnerAndCreate() {
        return customerMapper.selectCountOfCustomerByOwnerAndCreate();
    }

    @Override
    public List<LBVO> queryCountOfCustomerByCreateMonth() {
        return customerMapper.selectCountOfCustomerByCreateMonth();
    }

    @Override
    public List<Customer> queryCustomerByAddress() {
        return customerMapper.selectCustomerByAddress();
    }

    @Override
    public PieVO queryCountOfCustomer(Map<String, Object> map) {
        return customerMapper.selectCountOfCustomer(map);
    }

    @Override
    public int queryCountOfNewCustomer(Map<String, Object> map) {
        return customerMapper.selectCountOfNewCustomer(map);
    }
}
