package com.qsy.workbench.service;

import com.qsy.workbench.pojo.TransactionHistory;

import java.util.List;

/**
 * @author qsy
 * @create 2022/5/4 - 9:02
 */
public interface TransactionHistoryService {
    List<TransactionHistory> queryTransactionHistoryForDetailByTranId(String tranId);

}
