package com.qsy.workbench.dao;

import com.qsy.workbench.pojo.Transaction;

public interface TransactionMapper {
    int deleteByPrimaryKey(String id);

    int insert(Transaction row);

    int insertSelective(Transaction row);

    Transaction selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Transaction row);

    int updateByPrimaryKey(Transaction row);

    //线索转换中，创建一条交易记录
    int insertTransaction(Transaction transaction);
}