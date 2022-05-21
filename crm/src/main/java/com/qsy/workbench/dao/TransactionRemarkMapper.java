package com.qsy.workbench.dao;

import com.qsy.workbench.pojo.TransactionRemark;
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
    int insertTransactionRemarkByList(List<TransactionRemark> trList);

    //查询指定交易的备注信息
    List<TransactionRemark> selectTransactionRemarkForDetailByTranId(String tranId);

    //添加一条备注
    int insertTransactionRemark(TransactionRemark transactionRemark);

    //删除一条备注
    int deleteTransactionRemarkById(String id);

    //修改一条备注
    int updateTransactionRemark(TransactionRemark transactionRemark);

    //根据交易id删除所有该交易的备注
    int deleteTransactionRemarkByTranId(String[] tranId);


}