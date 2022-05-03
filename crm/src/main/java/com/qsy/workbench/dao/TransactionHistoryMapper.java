package com.qsy.workbench.dao;

import com.qsy.workbench.pojo.TransactionHistory;

public interface TransactionHistoryMapper {
    int deleteByPrimaryKey(String id);

    int insert(TransactionHistory row);

    int insertSelective(TransactionHistory row);

    TransactionHistory selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(TransactionHistory row);

    int updateByPrimaryKey(TransactionHistory row);

    int insertTransactionHistory(TransactionHistory transactionHistory);
}