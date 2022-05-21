package com.qsy.workbench.controller;

import com.qsy.settings.pojo.User;
import com.qsy.utils.Constants;
import com.qsy.utils.DateUtils;
import com.qsy.utils.IDUtils;
import com.qsy.utils.ReturnInfoObject;
import com.qsy.workbench.pojo.CustomerRemark;
import com.qsy.workbench.service.CustomerRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

/**
 * @author qsy
 * @create 2022/5/8 - 21:10
 */
@Controller
public class CustomerRemarkController {
    @Autowired
    private CustomerRemarkService customerRemarkService;
    @RequestMapping("/workbench/customer/addCustomerRemark.do")
    @ResponseBody
    public Object addCustomerRemark(CustomerRemark customerRemark, HttpSession session){
        User user = (User)session.getAttribute(Constants.SESSION_USER);
        customerRemark.setId(IDUtils.getId());
        customerRemark.setCreateBy(user.getId());
        customerRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
        customerRemark.setEditFlag(Constants.RETURN_EDIT_FLAG_NO_EDITED);

        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            int ret = customerRemarkService.addCustomerRemark(customerRemark);
            if(ret>0){
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnInfoObject.setReturnData(customerRemark);
            }else{
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnInfoObject.setMessage("系统忙，请稍后重试···");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("系统忙，请稍后重试···");
        }
        return returnInfoObject;
    }

    @RequestMapping("/workbench/customer/deleteCustomerRemark.do")
    @ResponseBody
    public Object deleteCustomerRemark(String id){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            int ret = customerRemarkService.deleteCustomerRemarkById(id);
            if(ret>0){
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnInfoObject.setMessage("系统忙，请稍后重试···");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("系统忙，请稍后重试···");
        }
        return returnInfoObject;
    }

    @RequestMapping("/workbench/customer/editCustomerRemark.do")
    @ResponseBody
    public  Object editCustomerRemark(CustomerRemark cr, HttpSession session){
        User user = (User)session.getAttribute(Constants.SESSION_USER);
        cr.setEditFlag(Constants.RETURN_EDIT_FLAG_HAVE_EDITED);
        cr.setEditBy(user.getId());
        cr.setEditTime(DateUtils.formatDateTime(new Date()));

        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            int ret = customerRemarkService.editCustomerRemark(cr);
            if(ret>0){
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnInfoObject.setReturnData(cr);
            }else{
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnInfoObject.setMessage("系统忙，请稍后重试···");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("系统忙，请稍后重试···");
        }
        return  returnInfoObject;
    }
}
