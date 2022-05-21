package com.qsy.workbench.dao;

import com.qsy.workbench.pojo.TransactionHistory;

import java.util.List;

public interface TransactionHistoryMapper {
    int deleteByPrimaryKey(String id);

    int insert(TransactionHistory row);

    int insertSelective(TransactionHistory row);

    TransactionHistory selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(TransactionHistory row);

    int updateByPrimaryKey(TransactionHistory row);

    int insertTransactionHistory(TransactionHistory transactionHistory);

    //查询指定交易的交易历史
    List<TransactionHistory> selectTransactionHistoryForDetailByTranId(String tranId);

    int deleteTransactionHistoryByTranId(String[] tranId);
}