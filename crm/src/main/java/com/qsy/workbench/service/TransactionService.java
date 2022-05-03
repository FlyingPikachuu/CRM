package com.qsy.workbench.service;

import com.qsy.workbench.pojo.Transaction;

import java.util.List;
import java.util.Map;

/**
 * @author qsy
 * @create 2022/4/25 - 9:51
 */
public interface TransactionService {
    //根据条件查询交易信息
    List<Transaction> queryTransactionByConditionForPage(Map<String,Object> map);

    //根据条件查询交易总条数
    int queryCountOfTransactionByCondition(Map<String,Object> map);

    void saveTransaction(Map<String,Object> map);
}
