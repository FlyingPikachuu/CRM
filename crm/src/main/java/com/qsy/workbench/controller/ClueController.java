package com.qsy.workbench.controller;

import com.qsy.settings.pojo.DicValue;
import com.qsy.settings.pojo.User;
import com.qsy.settings.service.DicValueService;
import com.qsy.settings.service.UserService;
import com.qsy.workbench.pojo.*;
import com.qsy.workbench.service.*;
import com.qsy.utils.Constants;
import com.qsy.utils.DateUtils;
import com.qsy.utils.IDUtils;
import com.qsy.utils.ReturnInfoObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.*;

/**
 * @author qsy
 * @create 2022/4/14 - 9:42
 */
@Controller
public class ClueController {

    @Autowired
    private CLueService cLueService;

    @Autowired
    private UserService userService;

    @Autowired
    private DicValueService dicValueService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private ClueRemarkService clueRemarkService;

    @Autowired
    private ClueActivityRelationService clueActivityRelationService;

    @RequestMapping("/workbench/clue/index.do")
    public String index(Model model){
        List<User> userList = userService.queryAllUser();

        List<DicValue> appellation = dicValueService.queryDicValueByTypeCode("appellation");
        List<DicValue> clueState = dicValueService.queryDicValueByTypeCode("clueState");
        List<DicValue> source = dicValueService.queryDicValueByTypeCode("source");

        model.addAttribute("userList",userList);
        model.addAttribute("appellation",appellation);
        model.addAttribute("clueState",clueState);
        model.addAttribute("source",source);

        return "/workbench/clue/index";
    }


    @RequestMapping("/workbench/clue/saveClue.do")
    @ResponseBody
    public Object saveClue(Clue clue, HttpSession session){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        User user = (User)session.getAttribute(Constants.SESSION_USER);

        //封装参数
        clue.setId(IDUtils.getId());
        clue.setCreateTime(DateUtils.formatDateTime(new Date()));
        clue.setCreateBy(user.getId());


        try {
            int ret = cLueService.addClue(clue);
            if(ret>0){
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
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
        return returnInfoObject;
    }

    @RequestMapping("/workbench/clue/queryClueForPageByCondition.do")
    @ResponseBody
    public  Object queryClueForPageByCondition(String fullname,String company,String phone,String owner,String mphone
                                               ,String source,String state,int pageNo,int pageSize){
        //封装参数
        Map<String, Object> map = new HashMap<>();
        map.put("fullname",fullname);
        map.put("company",company);
        map.put("phone",phone);
        map.put("owner",owner);
        map.put("mphone",mphone);
        map.put("source",source);
        map.put("state",state);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);

        List<Clue> clueList = cLueService.queryClueForPageByCondition(map);
        int totalRows = cLueService.queryCountOfClueByCondition(map);

        Map<String, Object> retMap = new HashMap<>();
        retMap.put("clueList",clueList);
        retMap.put("totalRows",totalRows);

        return  retMap;
    }

    @RequestMapping("/workbench/clue/clueDetail.do")
    public String clueDetail(String id, Model model){
        List<ClueRemark> clueRemarkList = clueRemarkService.queryClueRemarkForDetailByClueId(id);
        Clue clue = cLueService.queryClueForDetailById(id);
        List<Activity> activityList = activityService.queryActivityForClueDetailByClueId(id);

        model.addAttribute("clue",clue);
        model.addAttribute("clueRemarkList",clueRemarkList);
        model.addAttribute("activityList",activityList);

        return "/workbench/clue/detail";
    }

    @RequestMapping("/workbench/clue/queryActivityByName.do")
    @ResponseBody
    public Object queryActivityByName(String activityName,String clueId){
        Map<String, Object> map = new HashMap<>();
        map.put("activityName",activityName);
        map.put("clueId",clueId);
        List<Activity> activityList = activityService.queryActivityForDetailByNameExpClueId(map);

        return activityList;
    }

    @RequestMapping("/workbench/clue/addRelation.do")
    @ResponseBody
    public Object addRelation(String[] activityId,String clueId){

        ReturnInfoObject returnInfoObject=new ReturnInfoObject();
        ClueActivityRelation car=null;
        ArrayList<ClueActivityRelation> relationList = new ArrayList<>();
        for (String ai : activityId) {
            car=new ClueActivityRelation();
            car.setId(IDUtils.getId());
            car.setActivityId(ai);
            car.setClueId(clueId);
            relationList.add(car);
        }
        System.out.println(relationList);
        try {
            int ret = clueActivityRelationService.addClueActivityRelation(relationList);
            if(ret>0){
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                List<Activity> activityList = activityService.queryActivityForBundByIds(activityId);
                returnInfoObject.setReturnData(activityList);
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
        return returnInfoObject;
    }

    @RequestMapping("/workbench/clue/deleteRelation.do")
    @ResponseBody
    public Object deleteRelation(ClueActivityRelation clueActivityRelation){
        System.out.println(clueActivityRelation.getActivityId());
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            int ret = clueActivityRelationService.deleteClueActivityRelationByActivityIdClueId(clueActivityRelation);
            if(ret>0){
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
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
        return returnInfoObject;
    }
    @RequestMapping("/workbench/clue/toConvert.do")
    public String toConvert(String id,Model model){
        Clue clue = cLueService.queryClueForDetailById(id);
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");

        model.addAttribute("clue",clue);
        model.addAttribute("stageList",stageList);

        return "/workbench/clue/convert";
    }

    @RequestMapping("/workbench/clue/searchActivity.do")
    @ResponseBody
    public Object searchActivity(String activityName,String clueId){
        Map<String, Object> map = new HashMap<>();
        map.put("activityName",activityName);
        map.put("clueId",clueId);

        List<Activity> activityList = activityService.queryActivityFroConvertByNameClueId(map);
        System.out.println(activityList);
        return  activityList;
    }

    @RequestMapping("/workbench/clue/saveConvertClue.do")
    @ResponseBody
    public Object saveConvertClue(@RequestParam Map<String,Object> map, HttpSession session){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        map.put(Constants.SESSION_USER,session.getAttribute(Constants.SESSION_USER));

        try {
            cLueService.saveConvertClue(map);
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("系统忙，请稍后重试···");
        }
        return  returnInfoObject;
    }

}
