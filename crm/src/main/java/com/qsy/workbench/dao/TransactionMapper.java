package com.qsy.workbench.dao;

import com.qsy.workbench.pojo.*;

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

    //查询指定交易明细
    Transaction selectTransactionForDetailById(String id);



    //根据Id查询交易信息填入修改页面
    Transaction selectTranById(String id);
    //修改交易
    int updateTranById(Transaction transaction);

    //删除交易
    int deleteTranByIds(String[] ids);

    //根据ContactId查询交易信息
    List<Transaction> selectTranByContactId(String contactId);
    //根据CustomerId查询交易信息
    List<Transaction> selectTranByCustomerId(String customerId);

    //因为删除联系人，修改相关交易联系人为空
    int updateTransactionByContactId(String[] contactId);

    //因为删除客户，删除相关交易
    int deleteTransactionByCustomerId(String[] customerId);

    //根据阶段分组查询交易数量
    List<FunnelVO> selectCountOfTranGroupByStage(Map<String,Object> map);

    //查询交易客户成交金额TOP10
    //查询交易客户交易数量
    List<LBVO> selectCountOfTranAndSumMoneyGroupByCut();

    //查询当年每月创建线索总数量
    //查询当年当月成交线索总数量
    List<LBVO> selectCountOfTranByCreateMonth();

    //查询当年当月职员成交线索金额总数TOP10
    List<LBVO> selectSumMoneyGroupByOwner();
    PieVO selectCountOfTran(Map<String,Object> map);

    int selectCountOfNewTran(Map<String,Object> map);

    //修改指定交易的阶段
    int updateTranByStage(Map<String,Object> map);
}