package com.qsy.workbench.dao;

import com.qsy.workbench.pojo.*;
import com.qsy.workbench.pojo.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerMapper {
    int deleteByPrimaryKey(String id);

    int insert(Customer row);

    int insertSelective(Customer row);

    Customer selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Customer row);

    int updateByPrimaryKey(Customer row);

    //添加客户信息
    int insertCustomer(Customer customer);

    List<String> selectCustomerNameByName(String name);

    Customer selectCustomerByName(String name);

    //根据条件分页查询客户
    List<Customer> selectCustomerByConditionForPage(Map<String,Object> map);
    //根据条件分页查询客户总条数
    int selectCountOfCustomerByCondition(Map<String,Object> map);
    //根据id查询客户信息显示到修改模态窗口
    Customer selectCustomerById(String id);
    //根据id修改指定客户
    int updateCustomerById(Customer customer);
    //根据ids批量删除客户
    int deleteCustomerByIds(String[] ids);

    //查询客户明细
    Customer selectCustomerByIdForDetail(String id);


    //根据客户地址查询客户数量 piechart
    List<FunnelVO> selectCountOfCustomerByCutAddress();

    //查询当月职员创建客户TOP10
    List<LBVO> selectCountOfCustomerByOwnerAndCreate();

    //查询当年每月创建客户数量和每月创建交易数量对比
    List<LBVO> selectCountOfCustomerByCreateMonth();

    //查询成交总额前五的北京客户名称，所有人，座机,总成交额
    List<Customer> selectCustomerByAddress();

    //查询客户创建交易交易占比
    PieVO selectCountOfCustomer(Map<String,Object> map);

    int selectCountOfNewCustomer(Map<String,Object> map);
}