package com.qsy.workbench.controller;

import com.qsy.settings.pojo.User;
import com.qsy.settings.service.UserService;
import com.qsy.utils.Constants;
import com.qsy.utils.DateUtils;
import com.qsy.utils.IDUtils;
import com.qsy.utils.ReturnInfoObject;
import com.qsy.workbench.pojo.Contact;
import com.qsy.workbench.pojo.Customer;
import com.qsy.workbench.pojo.CustomerRemark;
import com.qsy.workbench.pojo.Transaction;
import com.qsy.workbench.service.ContactService;
import com.qsy.workbench.service.CustomerRemarkService;
import com.qsy.workbench.service.CustomerService;
import com.qsy.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.*;

/**
 * @author qsy
 * @create 2022/4/25 - 10:00
 */
@Controller
public class CustomerController {
    @Autowired
    private CustomerService customerService;
    @Autowired
    private UserService userService;
    @Autowired
    private CustomerRemarkService customerRemarkService;
    @Autowired
    private TransactionService transactionService;
    @Autowired
    private ContactService contactService;
    @RequestMapping("workbench/customer/index.do")
    public  String index(Model model){
        List<User> userList = userService.queryAllUser();
        model.addAttribute("userList",userList);
        return "workbench/customer/index";
    }

    @RequestMapping("/workbench/customer/queryCustomerByConditionForPage.do")
    @ResponseBody
    public  Object queryCustomerByConditionForPage(@RequestParam Map<String,Object> map){
        int pageNo =Integer.parseInt(map.get("pageNo").toString());
        int  pageSize = Integer.parseInt(map.get("pageSize").toString());
        System.out.println(pageNo+","+pageSize);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);
        List<Customer> cutList = customerService.queryCustomerByConditionForPage(map);
        int totalRows = customerService.queryCountOfCustomerByCondition(map);

        HashMap<String, Object> retMap = new HashMap<>();
        retMap.put("cutList",cutList);
        retMap.put("totalRows",totalRows);

        return retMap;
    }
    //添加联系人
    @RequestMapping("/workbench/customer/addCustomer.do")
    @ResponseBody
    public Object addCustomer(Customer customer, HttpSession session){
        User user = (User)session.getAttribute(Constants.SESSION_USER);
        customer.setId(IDUtils.getId());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(DateUtils.formatDateTime(new Date()));
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            int ret = customerService.addCustomer(customer);
            if(ret>0){
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnInfoObject.setMessage("系统忙，请重试···");
            }
        } catch (Exception e) {
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("系统忙，请重试···");
        }
        return returnInfoObject;
    }

    //查询指定联系人信息
    @RequestMapping("/workbench/customer/queryCustomerByIdForEdit.do")
    @ResponseBody
    public Object queryCustomerByIdForEdit(String id){
        Customer customer = customerService.queryCustomerById(id);
        return customer;
    }

    @RequestMapping("/workbench/customer/editCustomer.do")
    @ResponseBody
    public  Object editCustomer(Customer customer, HttpSession session){
        User user = (User)session.getAttribute(Constants.SESSION_USER);
        customer.setEditBy(user.getId());
        customer.setEditTime(DateUtils.formatDateTime(new Date()));
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            int ret = customerService.editCustomerById(customer);
            if(ret>0){
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnInfoObject.setMessage("系统忙，请重试···");
            }
        } catch (Exception e) {
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("系统忙，请重试···");
        }
        return returnInfoObject;
    }

    //删除联系人
    @RequestMapping("/workbench/customer/deleteCustomer.do")
    @ResponseBody
    public Object deleteCustomer(String[] ids){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            customerService.deleteCustomer(ids);
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("系统忙，请稍后重试···");
        }
        return  returnInfoObject;
    }

    @RequestMapping("/workbench/customer/toDetail.do/{id}")
    public String toDetail(@PathVariable String id,Model model){
        List<User> userList = userService.queryAllUser();
        Customer cut = customerService.queryCustomerByIdForDetail(id);
        List<CustomerRemark> cutrList = customerRemarkService.queryCustomerRemarkForDetailByCustomerId(id);
        List<Transaction> tranList = transactionService.queryTranByCustomerId(id);
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        for (Transaction t : tranList) {
            String stage = t.getStage();
            String possibility = bundle.getString(stage);
            t.setPossibility(possibility);
        }
        List<Contact> cotList = contactService.queryContactByCustomerId(id);

        model.addAttribute("userList",userList);
        model.addAttribute("cut",cut);
        model.addAttribute("cutrList",cutrList);
        model.addAttribute("tranList",tranList);
        model.addAttribute("cotList",cotList);
        return "workbench/customer/detail";
    }
}
