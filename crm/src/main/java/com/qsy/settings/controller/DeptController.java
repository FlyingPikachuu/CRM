package com.qsy.settings.controller;

import com.qsy.settings.pojo.Dept;
import com.qsy.settings.service.DeptService;
import com.qsy.utils.Constants;
import com.qsy.utils.ReturnInfoObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;

/**
 * @author qsy
 * @create 2022/4/20 - 11:10
 */
@Controller
public class DeptController {
    @Autowired
    private DeptService deptService;
    @RequestMapping("/settings/dept/main.do")
    public  String main(){
        return "settings/dept/main";
    }
    @RequestMapping("/settings/dept/index.do")
    public  String index(Model model){
        List<Dept> deptList = deptService.queryAllDept();
        model.addAttribute("deptList",deptList);
        return "settings/dept/index";
    }
    @RequestMapping("/settings/dept/addDept.do")
    @ResponseBody
    public Object addDept(Dept dept){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        Dept dept1 = deptService.queryDeptByCode(dept.getCode());
        if(dept1==null){
            try {
                int ret = deptService.addDept(dept);
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
        }else{
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("代码已存在");
        }

        return returnInfoObject;
    }

    @RequestMapping("/settings/dept/queryDeptByCode.do")
    @ResponseBody
    public Object queryDeptByCode(String code){
        Dept dept = deptService.queryDeptByCode(code);
        return  dept;
    }
    @RequestMapping("/settings/dept/editDept.do")
    @ResponseBody
    public  Object editDept(@RequestParam Map<String,Object> map){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();

        if(!map.get("code").equals(map.get("oldCode"))){
            Dept dept = deptService.queryDeptByCode((String) map.get("code"));
            if(dept==null){
                try {
                    deptService.editDeptByCode(map);
                    returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                } catch (Exception e) {
                    e.printStackTrace();
                    returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                    returnInfoObject.setMessage("系统忙，请稍后重试···");
                }
            }else{
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnInfoObject.setMessage("代码已存在");
            }
        }else {
            try {
                deptService.editDeptByCode(map);
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            } catch (Exception e) {
                e.printStackTrace();
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnInfoObject.setMessage("系统忙，请稍后重试···");
            }
        }

        return returnInfoObject;
    }

    @RequestMapping("/settings/dept/deleteDept.do")
    @ResponseBody
    public Object deleteDept(String[] code){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            deptService.deleteDeptByCode(code);
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("系统忙，请稍后重试···");
        }
        return  returnInfoObject;
    }


}
