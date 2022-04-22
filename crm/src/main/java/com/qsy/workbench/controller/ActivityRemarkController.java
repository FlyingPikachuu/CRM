package com.qsy.workbench.controller;

import com.qsy.workbench.pojo.ActivityRemark;
import com.qsy.utils.ReturnInfoObject;
import com.qsy.settings.pojo.User;
import com.qsy.workbench.service.ActivityRemarkService;
import com.qsy.utils.Constants;
import com.qsy.utils.DateUtils;
import com.qsy.utils.IDUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

/**
 * @author qsy
 * @create 2022/4/5 - 10:18
 */
@Controller
public class ActivityRemarkController {
    @Autowired
    private ActivityRemarkService activityRemarkService;
    @RequestMapping("workbench/activity/addActivityRemark.do")
    @ResponseBody
    public Object addActivityRemark(ActivityRemark activityRemark, HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        activityRemark.setId(IDUtils.getId());
        activityRemark.setCreateBy(user.getId());
        activityRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
        activityRemark.setEditFlag(Constants.RETURN_EDIT_FLAG_NO_EDITED);
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            int i = activityRemarkService.addActivityRemark(activityRemark);
            if(i>0){
                returnInfoObject.setCode("1");
                returnInfoObject.setReturnData(activityRemark);
            }
            else{
                returnInfoObject.setCode("0");
                returnInfoObject.setMessage("系统忙，请稍后重试···");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnInfoObject.setCode("0");
            returnInfoObject.setMessage("系统忙，请稍后重试···");
        }
        return  returnInfoObject;
    }

    @RequestMapping("workbench/activity/deleteActivityRemarkById.do")
    @ResponseBody
    public Object deleteActivityRemarkById(String id){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            int ret = activityRemarkService.deleteActivityRemarkById(id);
            if(ret>0){
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }
            else {
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

    @RequestMapping("workbench/activity/updateActivityRemark.do")
    @ResponseBody
    public Object updateActivityRemark(HttpSession session,ActivityRemark activityRemark){
        System.out.println(activityRemark.getNoteContent());
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        activityRemark.setEditFlag(Constants.RETURN_EDIT_FLAG_HAVE_EDITED);
        activityRemark.setEditBy(user.getId());
        activityRemark.setEditTime(DateUtils.formatDateTime(new Date()));
        try {
            int ret = activityRemarkService.editActivityRemark(activityRemark);
            if(ret>0){
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnInfoObject.setReturnData(activityRemark);
            }
            else{
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
