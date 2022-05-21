package com.qsy.workbench.controller;

import com.qsy.settings.pojo.User;
import com.qsy.utils.Constants;
import com.qsy.utils.DateUtils;
import com.qsy.utils.IDUtils;
import com.qsy.utils.ReturnInfoObject;
import com.qsy.workbench.pojo.TransactionRemark;
import com.qsy.workbench.service.TransactionRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

/**
 * @author qsy
 * @create 2022/5/6 - 7:36
 */
@Controller
public class TransactionRemarkController {
    @Autowired
    private TransactionRemarkService transactionRemarkService;

    @RequestMapping("/workbench/transaction/addTranRemark.do")
    @ResponseBody
    public Object addTranRemark(TransactionRemark transactionRemark, HttpSession session){
        User user = (User)session.getAttribute(Constants.SESSION_USER);
        transactionRemark.setId(IDUtils.getId());
        transactionRemark.setCreateBy(user.getId());
        transactionRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
        transactionRemark.setEditFlag(Constants.RETURN_EDIT_FLAG_NO_EDITED);

        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            int ret = transactionRemarkService.addTransactionRemark(transactionRemark);
            if(ret>0){
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnInfoObject.setReturnData(transactionRemark);
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

    @RequestMapping("/workbench/transaction/deleteTranRemark.do")
    @ResponseBody
    public Object deleteTranRemark(String id){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            int ret = transactionRemarkService.deleteTransactionRemarkById(id);
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

    @RequestMapping("/workbench/transaction/editTranRemark.do")
    @ResponseBody
    public  Object editTranRemark(TransactionRemark tr,HttpSession session){
        User user = (User)session.getAttribute(Constants.SESSION_USER);
        tr.setEditFlag(Constants.RETURN_EDIT_FLAG_HAVE_EDITED);
        tr.setEditBy(user.getId());
        tr.setEditTime(DateUtils.formatDateTime(new Date()));

        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            int ret = transactionRemarkService.editTransactionRemark(tr);
            if(ret>0){
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnInfoObject.setReturnData(tr);
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
