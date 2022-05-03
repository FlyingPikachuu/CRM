package com.qsy.workbench.service.impl;

import com.qsy.settings.pojo.User;
import com.qsy.utils.Constants;
import com.qsy.utils.DateUtils;
import com.qsy.utils.IDUtils;
import com.qsy.workbench.dao.CustomerMapper;
import com.qsy.workbench.dao.TransactionHistoryMapper;
import com.qsy.workbench.dao.TransactionMapper;
import com.qsy.workbench.pojo.Customer;
import com.qsy.workbench.pojo.Transaction;
import com.qsy.workbench.pojo.TransactionHistory;
import com.qsy.workbench.service.TransactionService;
import org.aspectj.apache.bcel.classfile.Constant;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @author qsy
 * @create 2022/4/25 - 9:52
 */
@Service
public class TransactionServiceImpl implements TransactionService{
    @Autowired
    private TransactionMapper transactionMapper;
    @Autowired
    private  TransactionHistoryMapper transactionHistoryMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Override
    public List<Transaction> queryTransactionByConditionForPage(Map<String, Object> map) {
        return transactionMapper.selectTransactionByConditionForPage(map);
    }

    @Override
    public int queryCountOfTransactionByCondition(Map<String, Object> map) {
        return transactionMapper.selectCountOfTransactionByCondition(map);
    }

    @Override
    public void saveTransaction(Map<String, Object> map) {
        String customerName= (String)map.get("customerName");
        Customer customer = customerMapper.selectCustomerByName(customerName);
        User user = (User)map.get(Constants.SESSION_USER);
        if(customer==null){
            customer = new Customer();
            customer.setId(IDUtils.getId());
            customer.setOwner(user.getId());
            customer.setName(customerName);
            customer.setCreateBy(user.getId());
            customer.setCreateTime(DateUtils.formatDateTime(new Date()));
            customerMapper.insertCustomer(customer);
        }

        Transaction ts = new Transaction();
        ts.setId(IDUtils.getId());
        ts.setCreateTime(DateUtils.formatDateTime(new Date()));
        ts.setActivityId((String) map.get("activityId"));
        ts.setCreateBy(user.getId());
        ts.setOwner(user.getId());
        ts.setName((String) map.get("name"));
        ts.setStage((String) map.get("stage"));
        ts.setMoney((String) map.get("money"));
        ts.setExpectedDate((String) map.get("expectedDate"));
        ts.setCustomerId(customer.getId());
        ts.setContactId((String) map.get("contactId"));
        ts.setContactSummary((String) map.get("contactSummary"));
        ts.setDescription((String) map.get("description"));
        ts.setNextContactTime((String) map.get("nextContactTime"));
        ts.setSource((String) map.get("source"));
        ts.setType((String) map.get("type"));
        transactionMapper.insertTransaction(ts);
        //创建交易历史
        TransactionHistory tsh = new TransactionHistory();
        tsh.setId(IDUtils.getId());
        tsh.setMoney(ts.getMoney());
        tsh.setStage(ts.getStage());
        tsh.setCreateBy(user.getId());
        tsh.setCreateTime(DateUtils.formatDateTime(new Date()));
        tsh.setTranId(ts.getId());
        tsh.setExpectedDate(ts.getExpectedDate());
        transactionHistoryMapper.insertTransactionHistory(tsh);
    }
}
