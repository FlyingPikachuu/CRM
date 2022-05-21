package com.qsy.workbench.service.impl;

import com.qsy.workbench.dao.TransactionRemarkMapper;
import com.qsy.workbench.pojo.TransactionRemark;
import com.qsy.workbench.service.TransactionRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author qsy
 * @create 2022/5/4 - 9:02
 */
@Service
public class TransactionRemarkServiceImpl implements TransactionRemarkService {
    @Autowired
    private TransactionRemarkMapper transactionRemarkMapper;
    @Override
    public List<TransactionRemark> queryTransactionRemarkForDetailByTranId(String tranId) {
        return transactionRemarkMapper.selectTransactionRemarkForDetailByTranId(tranId);
    }

    @Override
    public int addTransactionRemark(TransactionRemark transactionRemark) {
        return transactionRemarkMapper.insertTransactionRemark(transactionRemark);
    }

    @Override
    public int deleteTransactionRemarkById(String id) {
        return transactionRemarkMapper.deleteTransactionRemarkById(id);
    }

    @Override
    public int editTransactionRemark(TransactionRemark transactionRemark) {
        return transactionRemarkMapper.updateTransactionRemark(transactionRemark);
    }
}
