package com.qsy.workbench.service;

import com.qsy.workbench.pojo.*;

import java.util.List;
import java.util.Map;

/**
 * @author qsy
 * @create 2022/4/25 - 9:51
 */
public interface TransactionService {
    //根据条件查询交易信息
    List<Transaction> queryTransactionByConditionForPage(Map<String,Object> map);

    //根据条件查询交易总条数
    int queryCountOfTransactionByCondition(Map<String,Object> map);

    void saveTransaction(Map<String,Object> map);

    Transaction queryTransactionForDetailById(String id);

    List<FunnelVO> queryCountOfTranGroupByStage(Map<String,Object> map);

    //根据Id查询交易信息填入修改页面
    Transaction queryTranById(String id);
    //修改交易
    void editTransaction(Map<String, Object> map);

    //删除交易
    void deleteTranByIds(String[] ids);

    //根据ContactId查询交易信息
    List<Transaction> queryTranByContactId(String contactId);
    //根据CustomerId查询交易信息
    List<Transaction> queryTranByCustomerId(String customerId);

    //查询交易客户成交金额TOP10
    //查询交易客户交易数量
    List<LBVO> queryCountOfTranAndSumMoneyGroupByCut();

    //查询当年每月创建线索总数量
    //查询当年当月成交线索总数量
    List<LBVO> queryCountOfTranByCreateMonth();

    //查询当年当月职员成交线索金额总数TOP10
    List<LBVO> querySumMoneyGroupByOwner();

    PieVO queryCountOfTran(Map<String,Object> map);

    int queryCountOfNewTran(Map<String,Object> map);

    void editTranStage(Map<String,Object> map);

}
