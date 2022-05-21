package com.qsy.workbench.service;

import com.qsy.workbench.pojo.*;

import java.util.List;
import java.util.Map;

/**
 * @author qsy
 * @create 2022/5/3 - 9:20
 */
public interface CustomerService {

    List<String> queryCustomerNameByName(String name);

    //添加一个客户
    int addCustomer(Customer customer);
    //根据条件分页查询客户
    List<Customer> queryCustomerByConditionForPage(Map<String,Object> map);
    //根据条件分页查询客户总条数
    int queryCountOfCustomerByCondition(Map<String,Object> map);
    //根据id查询客户信息显示到修改模态窗口
    Customer queryCustomerById(String id);
    //根据id修改指定客户
    int editCustomerById(Customer customer);
    //根据ids批量删除客户
    void deleteCustomer(String[] ids);

    Customer queryCustomerByIdForDetail(String id);


    //根据客户地址查询客户数量 piechart
    List<FunnelVO> queryCountOfCustomerByCutAddress();

    //查询当月职员创建客户TOP10
    List<LBVO> queryCountOfCustomerByOwnerAndCreate();

    //查询当年每月创建客户数量和每月创建交易数量对比
    List<LBVO> queryCountOfCustomerByCreateMonth();

    //查询北京客户名称，所有人，座机
    List<Customer> queryCustomerByAddress();

    PieVO queryCountOfCustomer(Map<String,Object> map);

    int queryCountOfNewCustomer(Map<String,Object> map);

}
