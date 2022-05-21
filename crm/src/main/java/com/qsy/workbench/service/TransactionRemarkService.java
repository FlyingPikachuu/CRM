package com.qsy.workbench.service;

import com.qsy.workbench.pojo.TransactionRemark;

import java.util.List;

/**
 * @author qsy
 * @create 2022/5/4 - 9:02
 */
public interface TransactionRemarkService {
    List<TransactionRemark> queryTransactionRemarkForDetailByTranId(String tranId);

    //添加一条备注
    int addTransactionRemark(TransactionRemark transactionRemark);

    //删除一条备注
    int deleteTransactionRemarkById(String id);

    //修改一条备注
    int editTransactionRemark(TransactionRemark transactionRemark);
}
