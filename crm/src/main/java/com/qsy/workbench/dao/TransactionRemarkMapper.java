package com.qsy.workbench.dao;

import com.qsy.workbench.pojo.TransactionRemark;

import java.util.List;

public interface TransactionRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insert(TransactionRemark row);

    int insertSelective(TransactionRemark row);

    TransactionRemark selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(TransactionRemark row);

    int updateByPrimaryKey(TransactionRemark row);

    //线索转换，将线索备注信息转换到交易备注表中一份
    int insertTransactionRemark(List<TransactionRemark> trList);
}