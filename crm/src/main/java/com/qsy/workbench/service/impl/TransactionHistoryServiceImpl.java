package com.qsy.workbench.service.impl;

import com.qsy.workbench.dao.TransactionHistoryMapper;
import com.qsy.workbench.pojo.TransactionHistory;
import com.qsy.workbench.service.TransactionHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author qsy
 * @create 2022/5/4 - 9:02
 */
@Service
public class TransactionHistoryServiceImpl implements TransactionHistoryService {
    @Autowired
    private TransactionHistoryMapper transactionHistoryMapper;
    @Override
    public List<TransactionHistory> queryTransactionHistoryForDetailByTranId(String tranId) {
        return transactionHistoryMapper.selectTransactionHistoryForDetailByTranId(tranId);
    }
}
