package com.qsy.workbench.dao;

import com.qsy.workbench.pojo.Activity;
import com.qsy.workbench.pojo.Transaction;

import java.util.List;
import java.util.Map;

public interface TransactionMapper {
    int deleteByPrimaryKey(String id);

    int insert(Transaction row);

    int insertSelective(Transaction row);

    Transaction selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Transaction row);

    int updateByPrimaryKey(Transaction row);

    //线索转换中，创建一条交易记录
    int insertTransaction(Transaction transaction);

    //根据条件查询交易信息
    List<Transaction> selectTransactionByConditionForPage(Map<String,Object> map);

    //根据条件查询交易总条数
    int selectCountOfTransactionByCondition(Map<String,Object> map);
}