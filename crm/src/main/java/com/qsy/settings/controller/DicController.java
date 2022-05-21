package com.qsy.settings.controller;

import com.qsy.settings.dao.DicTypeMapper;
import com.qsy.settings.dao.DicValueMapper;
import com.qsy.settings.pojo.DicType;
import com.qsy.settings.pojo.DicValue;
import com.qsy.settings.service.DicTypeService;
import com.qsy.settings.service.DicValueService;
import com.qsy.utils.Constants;
import com.qsy.utils.IDUtils;
import com.qsy.utils.ReturnInfoObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jmx.export.metadata.ManagedOperation;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.management.modelmbean.ModelMBeanOperationInfo;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author qsy
 * @create 2022/5/10 - 8:47
 */
@Controller
public class DicController {
    @Autowired
    private DicTypeService dicTypeService;
    @Autowired
    private DicValueService dicValueService;
    @RequestMapping("/settings/dictionary/index.do")
    public String index(){
        return "settings/dictionary/index";
    }
    @RequestMapping("/settings/dictionary/type/index.do")
    public String typeIndex(){
        return "settings/dictionary/type/index";
    }
    @RequestMapping("/settings/dictionary/value/index.do")
    public String valueIndex(Model model){
        List<DicType> dicTypeList = dicTypeService.queryAllDicType();
        model.addAttribute("dicTypeList",dicTypeList);
        return "settings/dictionary/value/index";
    }
    @RequestMapping("/settings/dictionary/type/queryDicTypeForPageByCondition.do")
    @ResponseBody
    public Object queryDicTypeForPageByCondition(@RequestParam Map<String,Object> map){
        int pageNo = Integer.parseInt(map.get("pageNo").toString());
        int pageSize = Integer.parseInt(map.get("pageSize").toString());
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);
        System.out.println(map);

        List<DicType> dicTypeList = dicTypeService.queryDicTypeForPageByCondition(map);
        int totalRows = dicTypeService.queryCountOfDicTypeByCondition(map);
        HashMap<String, Object> retMap = new HashMap<>();
        retMap.put("dicTypeList",dicTypeList);
        retMap.put("totalRows",totalRows);
        return  retMap;
    }
    @RequestMapping("/settings/dictionary/type/toSave.do")
    public String toTypeSave(){
        return "settings/dictionary/type/save";
    }
    @RequestMapping("/settings/dictionary/type/verify.do")
    @ResponseBody
    public Object verify(String code){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        DicType dt = dicTypeService.queryDicTypeByCode(code);
        if(dt==null){
            returnInfoObject.setMessage("√");
        }else{
            returnInfoObject.setMessage("编码已存在，请重新输入");
        }
        return returnInfoObject;
    }
    @RequestMapping("/settings/dictionary/type/verifyEdit.do")
    @ResponseBody
    public Object verifyEdit(String code,String oldCode){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        if(!code.equals(oldCode)){
            DicType dt = dicTypeService.queryDicTypeByCode(code);
            if(dt==null){
                returnInfoObject.setMessage("√");
            }else{
                returnInfoObject.setMessage("编码已存在，请重新输入");
            }
        }else{
            returnInfoObject.setMessage("√");
        }

        return returnInfoObject;
    }
    @RequestMapping("/settings/dictionary/type/addType.do")
    @ResponseBody
    public  Object addType(DicType dicType){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            int ret = dicTypeService.addDicType(dicType);
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

    @RequestMapping("/settings/dictionary/type/toEdit.do/{code}")
    public String toTypeEdit(@PathVariable String code, Model model){
        DicType dt = dicTypeService.queryDicTypeByCode(code);
        model.addAttribute("dt",dt);
        return "settings/dictionary/type/edit";
    }
    @RequestMapping("/settings/dictionary/type/editType.do")
    @ResponseBody
    public  Object editType(@RequestParam Map<String,Object> map){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            int ret = dicTypeService.editDicType(map);
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

    @RequestMapping("/settings/dictionary/type/deleteType.do")
    @ResponseBody
    public Object deleteType(String[] code){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            dicTypeService.deleteDicTypeByCode(code);
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();

            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("系统忙，请稍后重试···");
        }
        return  returnInfoObject;
    }

    @RequestMapping("/settings/dictionary/value/queryDicValueForPageByCondition.do")
    @ResponseBody
    public Object queryDicValueForPageByCondition(@RequestParam Map<String,Object> map){
        int pageNo = Integer.parseInt(map.get("pageNo").toString());
        int pageSize = Integer.parseInt(map.get("pageSize").toString());
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);


        List<DicValue> dicValueList = dicValueService.queryDicValueForPageByCondition(map);
        int totalRows = dicValueService.queryCountOfDicValueByCondition(map);
        HashMap<String, Object> retMap = new HashMap<>();
        retMap.put("dicValueList",dicValueList);
        retMap.put("totalRows",totalRows);
        return  retMap;
    }

    @RequestMapping("/settings/dictionary/value/toSave.do")
    public String toValueSave(Model model){
        List<DicType> dtList = dicTypeService.queryAllDicType();
        model.addAttribute("dtList",dtList);
        return "settings/dictionary/value/save";
    }
    @RequestMapping("/settings/dictionary/value/verifyValue.do")
    @ResponseBody
    public Object verifyValue(String typeCode,String orderNo){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        DicValue dv = dicValueService.queryDicValueByTypeCodeAndOrderNo(typeCode,orderNo);
        if(dv==null){
            returnInfoObject.setMessage("√");
        }else{
            returnInfoObject.setMessage("排序号已存在，请重新输入");
        }
        return returnInfoObject;
    }
    @RequestMapping("/settings/dictionary/value/addValue.do")
    @ResponseBody
    public  Object addValue(DicValue dicValue){
        dicValue.setId(IDUtils.getId());
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            int ret = dicValueService.addDicValue(dicValue);
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
    @RequestMapping("/settings/dictionary/value/toEdit.do/{id}")
    public String toValueEdit(@PathVariable String id, Model model){
        DicValue dv = dicValueService.queryDicValueById(id);
        model.addAttribute("dv",dv);
        return "settings/dictionary/value/edit";
    }
    @RequestMapping("/settings/dictionary/value/editValue.do")
    @ResponseBody
    public  Object editValue(DicValue dicValue){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            int ret = dicValueService.editDicValue(dicValue);
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

    @RequestMapping("/settings/dictionary/value/deleteValue.do")
    @ResponseBody
    public Object deleteValue(String[] id){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            dicValueService.deleteDicValueById(id);
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();

            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("系统忙，请稍后重试···");
        }
        return  returnInfoObject;
    }


}
