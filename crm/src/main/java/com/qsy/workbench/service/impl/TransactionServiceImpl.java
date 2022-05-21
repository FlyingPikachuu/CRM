package com.qsy.workbench.service.impl;

import com.qsy.settings.pojo.User;
import com.qsy.utils.Constants;
import com.qsy.utils.DateUtils;
import com.qsy.utils.IDUtils;
import com.qsy.workbench.dao.CustomerMapper;
import com.qsy.workbench.dao.TransactionHistoryMapper;
import com.qsy.workbench.dao.TransactionMapper;
import com.qsy.workbench.dao.TransactionRemarkMapper;
import com.qsy.workbench.pojo.*;
import com.qsy.workbench.service.TransactionService;
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
    @Autowired
    private TransactionRemarkMapper transactionRemarkMapper;
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
        ts.setOwner((String) map.get("owner"));
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

    @Override
    public Transaction queryTransactionForDetailById(String id) {
        return transactionMapper.selectTransactionForDetailById(id);
    }

    @Override
    public List<FunnelVO> queryCountOfTranGroupByStage(Map<String,Object> map) {
        return transactionMapper.selectCountOfTranGroupByStage(map);
    }

    @Override
    public Transaction queryTranById(String id) {
        return transactionMapper.selectTranById(id);
    }

    @Override
    public void editTransaction(Map<String, Object> map) {
        User user = (User) map.get(Constants.SESSION_USER);
        String customerName = (String) map.get("customerName");
        Customer customer = customerMapper.selectCustomerByName(customerName);
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
        ts.setId((String) map.get("id"));
        System.out.println("++++++++++++++++++"+ts.getId());
        ts.setActivityId((String) map.get("activityId"));
        ts.setOwner((String) map.get("owner"));
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
        ts.setEditBy(user.getId());
        ts.setEditTime(DateUtils.formatDateTime(new Date()));
        transactionMapper.updateTranById(ts);
        //创建交易历史
        Transaction ts2 = transactionMapper.selectTranById((String) map.get("id"));
        TransactionHistory tsh = null;
        if(!map.get("stage").equals(ts2.getStage())){
            tsh = new TransactionHistory();
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

    @Override
    public void deleteTranByIds(String[] ids) {

        //删除交易备注信息
        transactionRemarkMapper.deleteTransactionRemarkByTranId(ids);
        //删除交易历史信息
        transactionHistoryMapper.deleteTransactionHistoryByTranId(ids);
        //删除当前交易信息
        transactionMapper.deleteTranByIds(ids);
    }

    @Override
    public List<Transaction> queryTranByContactId(String contactId) {
        return transactionMapper.selectTranByContactId(contactId);
    }

    @Override
    public List<Transaction> queryTranByCustomerId(String customerId) {
        return transactionMapper.selectTranByCustomerId(customerId);
    }

    @Override
    public List<LBVO> queryCountOfTranAndSumMoneyGroupByCut() {
        return transactionMapper.selectCountOfTranAndSumMoneyGroupByCut();
    }

    @Override
    public List<LBVO> queryCountOfTranByCreateMonth() {
        return transactionMapper.selectCountOfTranByCreateMonth();
    }

    @Override
    public List<LBVO> querySumMoneyGroupByOwner() {
        return transactionMapper.selectSumMoneyGroupByOwner();
    }

    @Override
    public PieVO queryCountOfTran(Map<String, Object> map) {
        return transactionMapper.selectCountOfTran(map);
    }

    @Override
    public int queryCountOfNewTran(Map<String, Object> map) {
        return transactionMapper.selectCountOfNewTran(map);
    }

    @Override
    public void editTranStage(Map<String, Object> map) {
        System.out.println(map);
        User user = (User)map.get(Constants.SESSION_USER);
        Transaction ts = transactionMapper.selectTranById((String) map.get("id"));

        transactionMapper.updateTranByStage(map);
        //创建交易历史
        TransactionHistory tsh = new TransactionHistory();
        tsh.setId(IDUtils.getId());
        tsh.setMoney(ts.getMoney());
        tsh.setStage((String) map.get("stage"));
        tsh.setCreateBy(user.getId());
        tsh.setCreateTime(DateUtils.formatDateTime(new Date()));
        tsh.setTranId(ts.getId());
        tsh.setExpectedDate(ts.getExpectedDate());
        transactionHistoryMapper.insertTransactionHistory(tsh);
    }
}
