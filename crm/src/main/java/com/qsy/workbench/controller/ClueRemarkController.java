package com.qsy.workbench.controller;

import com.qsy.settings.pojo.User;
import com.qsy.utils.Constants;
import com.qsy.utils.DateUtils;
import com.qsy.utils.IDUtils;
import com.qsy.utils.ReturnInfoObject;
import com.qsy.workbench.pojo.ClueRemark;
import com.qsy.workbench.service.ActivityService;
import com.qsy.workbench.service.ClueService;
import com.qsy.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

/**
 * @author qsy
 * @create 2022/4/15 - 14:31
 */
@Controller
public class ClueRemarkController {

    @Autowired
    private ClueRemarkService clueRemarkService;
    @Autowired
    private ClueService cLueService;
    @Autowired
    private ActivityService activityService;

    @RequestMapping("/workbench/clue/addClueRemark.do")
    @ResponseBody
    public Object addClueRemark(ClueRemark clueRemark, HttpSession session){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        User user=(User)session.getAttribute(Constants.SESSION_USER);
        clueRemark.setId(IDUtils.getId());
        clueRemark.setCreateBy(user.getId());
        clueRemark.setEditFlag(Constants.RETURN_EDIT_FLAG_NO_EDITED);
        clueRemark.setCreateTime(DateUtils.formatDateTime(new Date()));

        try {
            int ret = clueRemarkService.addClueRemark(clueRemark);
            if(ret>0){
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnInfoObject.setReturnData(clueRemark);
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

    @RequestMapping("/workbench/clue/editClueRemark.do")
    @ResponseBody
    public Object editClueRemark(ClueRemark clueRemark,HttpSession session){
        User user=(User)session.getAttribute(Constants.SESSION_USER);
        clueRemark.setEditFlag(Constants.RETURN_EDIT_FLAG_HAVE_EDITED);
        clueRemark.setEditBy(user.getId());
        clueRemark.setEditTime(DateUtils.formatDateTime(new Date()));

        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            int ret = clueRemarkService.editClueRemark(clueRemark);
            if(ret>0){
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnInfoObject.setReturnData(clueRemark);
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

    @RequestMapping("/workbench/clue/deleteClueRemark.do")
    @ResponseBody
    public Object deleteClueRemark(String id){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            int ret = clueRemarkService.deleteClueRemarkById(id);
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
        return  returnInfoObject;

    }
}
