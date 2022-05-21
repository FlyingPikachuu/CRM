package com.qsy.settings.controller;


import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.qsy.settings.pojo.*;

import com.qsy.settings.service.*;
import com.qsy.utils.*;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.management.relation.RoleList;
import javax.servlet.http.HttpSession;
import java.util.*;

/**
 * @author qsy
 * @create 2022/4/20 - 11:15
 */
@Controller
public class QxController {
    @Autowired
    private UserService userService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private DeptService deptService;
    @Autowired
    private PermissionService permissionService;
    @Autowired
    private RolePermissionRelationService rolePermissionRelationService;
    @RequestMapping("/settings/qx/index.do")
    public String index(){
        return "settings/qx/index";
    }
    @RequestMapping("/settings/qx/permission/index.do")
    public String permissionIndex(Model model) throws JsonProcessingException {
        List<Permission> pmList = permissionService.queryAllPermission();
        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(pmList);
        model.addAttribute("j",json);
        return "settings/qx/permission/index";
    }
//    @RequestMapping("/settings/qx/permission/queryAll.do")
//    @ResponseBody
//    public  Object queryAll(){
//        List<Permission> pmList = permissionService.queryAllPermission();
//        return pmList;
//    }
    @RequestMapping("/settings/qx/permission/queryPermissionById.do/{id}")
    public String queryPermissionById(@PathVariable int id,Model model){
        Permission pm = permissionService.queryPermissionById(id);
        model.addAttribute("pm",pm);
        return "settings/qx/permission/detail";
    }

    @RequestMapping("/settings/qx/permission/addPm.do")
    @ResponseBody
    public Object addPm(Permission pm){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        int id = permissionService.queryMaxId()+1;
        pm.setId(id);
        if(pm.getIsParent()==1){
            pm.setOpen(Constants.RETURN_OPEN);
        }
        pm.setOrderNo(String.valueOf(id));
        pm.setUrl(Constants.PERMISSION_DETAIL_URL+id);
        pm.setTarget(Constants.PERMISSION_DETAIL_TARGET);
        try {
            int ret = permissionService.addPermission(pm);
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
    @RequestMapping("/settings/qx/permission/editPm.do")
    @ResponseBody
    public  Object editPm(Permission pm){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            int ret = permissionService.editPermissionById(pm);
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
    @RequestMapping("/settings/qx/permission/deletePm.do")
    @ResponseBody
    public  Object deletePm(String id){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            int ret = permissionService.deletePermissionById(id);
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

    @RequestMapping("/settings/qx/role/index.do")
    public String roleIndex(Model model){
        List<Role> roleList = roleService.queryAllRole();
        model.addAttribute("roleList",roleList);
        return "settings/qx/role/index";
    }
    //跳转到用户管理页面
    @RequestMapping("/settings/qx/user/index.do")
    public String user(Model model){
        List<User> userList = userService.queryAllUser();
        model.addAttribute("userList",userList);
        return "settings/qx/user/index";
    }
    @RequestMapping("/settings/qx/user/detail.do/{id}")
    public String detail(Model model,@PathVariable String id) throws Exception {
        User user = userService.queryUserById(id);
        model.addAttribute("user",user);
        return "settings/qx/user/detail";
    }
    @RequestMapping("/settings/qx/user/queryUserById.do/{id}")
    @ResponseBody
    public Object queryUserById(@PathVariable String id){
        User newUser = userService.queryUserById(id);
        return newUser;
    }
    @RequestMapping("/settings/qx/user/detail.do/editUserById.do")
    @ResponseBody
    public  Object editUserById(User user,HttpSession session){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        User users = (User) session.getAttribute(Constants.SESSION_USER);
        String deptName = user.getDeptName();
        Dept dept = deptService.queryDeptByName(deptName);
        if(dept!=null){
            user.setDeptno(dept.getCode());
            user.setEditBy(users.getId());
            user.setEditTime(DateUtils.formatDateTime(new Date()));
            try {
                int var = userService.editUserById(user);
                if(var>0){
                    returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                }
                else {
                    returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                    returnInfoObject.setMessage("系统忙,请稍后重试···");
                }
            } catch (Exception e) {
                e.printStackTrace();
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnInfoObject.setMessage("系统忙,请稍后重试···");
            }
        }else{
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("客户不存在，请重新选择");
        }
        return returnInfoObject;
    }
    @RequestMapping("/settings/qx/user/queryPermissionByRoleIdForTree.do")
    @ResponseBody
    public Object queryPermissionByRoleIdForTree(String roleno){
        List<Permission> pmList = new ArrayList<>();
        Permission permission = null;
        String[] split = roleno.split(",");
        if(roleno.equals("null")||roleno.length()==0||roleno==null||roleno.equals("")) {
           return  null;
        }
        else{
            List<String> stringList = rolePermissionRelationService.queryPidByRoleIds(split);
            String retString = MyStringUtils.stringListUnionRet(stringList);
            System.out.println(retString);
            String[] ids = retString.split(",");
            for (String id1 : ids) {
                permission = permissionService.queryPermissionById(Integer.parseInt(id1));
                pmList.add(permission);
            }
          return pmList;
        }

    }

    @RequestMapping("/settings/qx/user/queryAssignedRole.do")
    @ResponseBody
    public  Object queryAssignedRole(String roleno){
        String[] retArray = null;
        List<Role> roleList = null;
        if(roleno.equals("null")||roleno.length()==0||roleno==null){
            return null;
        }else{
            retArray = roleno.split(",");
            roleList = roleService.queryAssignedRole(retArray);
        }
        return  roleList;

    }
    @RequestMapping("/settings/qx/user/queryNotAssignedRole.do")
    @ResponseBody
    public  Object queryNotAssignedRole(String roleno){
        String[] retArray = null;
        List<Role> roleList = null;
        if(roleno.equals("null")||roleno.length()==0||roleno==null){
            roleList = roleService.queryAllRole();
        }else{
            retArray = roleno.split(",");
            roleList = roleService.queryNotAssignedRole(retArray);
        }
        return  roleList;
    }
    @RequestMapping("/settings/qx/user/assignRoleToUser.do")
    @ResponseBody
    public Object assignRoleToUser(String rolenos,String id){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
//        String s = rolePermissionRelationService.queryPidByRoleId(roleno);
//        String[] ids = s.split(",");
//        List<Permission> pmList = new ArrayList<>();
//        Permission permission = null;
//        for (String id1 : ids) {
//            permission = new Permission();
//            Permission pm = permissionService.queryPermissionById(Integer.parseInt(id1));
//            pmList.add(pm);
//        }

        if(rolenos.equals("null")||rolenos.length()==0||rolenos==null){
            try {
                int ret = userService.editRoleNoById(id);
                if(ret>0){
                    returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                }else{
                    returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                    returnInfoObject.setMessage("系统忙,请稍后重试···");
                }
            } catch (Exception e) {
                e.printStackTrace();
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnInfoObject.setMessage("系统忙,请稍后重试···");
            }
        }
        else{
            String[] rno = rolenos.split(",");
            Role role= null;
            ArrayList<Role> roleList = new ArrayList<>();
            for (String s : rno) {
                role = roleService.queryRoleByCode(s);
                roleList.add(role);
            }
            try {
                int ret = userService.editRoleNoByRoleNo(rolenos,id);
                if(ret>0){
                    returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                    returnInfoObject.setReturnData(roleList);
                }else{
                    returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                    returnInfoObject.setMessage("系统忙,请稍后重试···");
                }
            } catch (Exception e) {
                e.printStackTrace();
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnInfoObject.setMessage("系统忙,请稍后重试···");
            }
        }


        return returnInfoObject;
    }
    @RequestMapping("/settings/qx/user/queryDeptNameByName.do")
    @ResponseBody
    public  Object queryDeptNameByName(String name){
        List<String> deptNameList = deptService.queryDeptNameByName(name);
        return deptNameList;
    }
    @RequestMapping("/settings/qx/user/addUser.do")
    @ResponseBody
    public Object addUser(User user, HttpSession session){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        User users = (User) session.getAttribute(Constants.SESSION_USER);
        String deptName = user.getDeptName();
        System.out.println(deptName);
        Dept dept = deptService.queryDeptByName(deptName);
        System.out.println(dept);
        if(dept!=null){
            user.setDeptno(dept.getCode());
            user.setId(IDUtils.getId());
            user.setCreateBy(users.getId());
            user.setCreatetime(DateUtils.formatDateTime(new Date()));
            try {
                int var = userService.addUser(user);
                if(var>0){
                    returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                }
                else {
                    returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                    returnInfoObject.setMessage("系统忙,请稍后重试···");
                }
            } catch (Exception e) {
                e.printStackTrace();
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnInfoObject.setMessage("系统忙,请稍后重试···");
            }
        }else{
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("客户不存在，请重新选择");
        }
        return returnInfoObject;
    }
    @RequestMapping("/settings/qx/user/queryUserByConditionForPage.do")
    @ResponseBody
    public Object queryUserByConditionForPage(String name,String deptno,String lockState,String startDateTime,
                                              String endDateTime,int pageNo,int pageSize){
        System.out.println(lockState);
        Map<String, Object> map = new HashMap<>();
        map.put("name",name);
        map.put("deptno",deptno);
        map.put("lockState",lockState);
        map.put("startDateTime",startDateTime);
        map.put("endDateTime",endDateTime);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);

        List<User> userList = userService.queryUserByConditionForPage(map);
        for (User user : userList) {
            if(user.getLockState().equals("1")||user.getLockState().equals("")){
                user.setLockStateName("启用");
            }else{
                user.setLockStateName("锁定");
            }
        }
        int totalRows= userService.queryCountOfUserByCondition(map);

        //根据查询结果生成响应信息
        Map<String, Object> retMap = new HashMap<>();
        retMap.put("userList",userList);
        retMap.put("totalRows",totalRows);
        return retMap;
    }

    @RequestMapping("/settings/qx/user/editLockState.do")
    @ResponseBody//启动/禁用用户
    public Object editLockState(String lockState,String id){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        HashMap<String, Object> map = new HashMap<>();
        map.put("id",id);
        System.out.println("前台"+lockState);
        if(lockState.equals("1")||lockState.equals(null)) {
            lockState = "0";
        }
        else{
            lockState="1";
        }
        map.put("lockState",lockState);
        System.out.println(map);
        try {
            int ret = userService.editLockStateOfUserById(map);
            if(ret>0){
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
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

    @RequestMapping("/settings/qx/role/addRole.do")
    @ResponseBody
    public Object addRole(Role role){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        Role role1 = roleService.queryRoleByCode(role.getCode());
        if(role1==null){
            try {
                int ret = roleService.addRole(role);
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
    @RequestMapping("/settings/qx/role/queryRoleByCode.do")
    @ResponseBody
    public Object queryRoleByCode(String code){
        Role role = roleService.queryRoleByCode(code);
        return role;
    }
    @RequestMapping("/settings/qx/role/editRole.do")
    @ResponseBody
    public  Object editRole(@RequestParam Map<String,Object> map){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        if(!map.get("code").equals(map.get("oldCode"))){
            Role role = roleService.queryRoleByCode((String) map.get("code"));
            if(role==null){
                try {
                    roleService.editRoleByCode(map);
                    returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                } catch (Exception e) {
                    e.printStackTrace();
                    returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                    returnInfoObject.setMessage("系统忙，请稍后重试···");
                }
            } else{
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnInfoObject.setMessage("代码已存在");
            }
        }else {
            try {
                roleService.editRoleByCode(map);
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            } catch (Exception e) {
                e.printStackTrace();
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnInfoObject.setMessage("系统忙，请稍后重试···");
            }
        }

        return returnInfoObject;
    }

    @RequestMapping("/settings/qx/role/deleteRole.do")
    @ResponseBody
    public Object deleteRole(String[] code){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            roleService.deleteRoleByCode(code);
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("系统忙，请稍后重试···");
        }
        return  returnInfoObject;
    }
    @RequestMapping("/settings/qx/role/toDetail.do/{code}")
    public  String toDetail(@PathVariable String code,Model model) throws JsonProcessingException {
        Role role = roleService.queryRoleByCode(code);
        model.addAttribute("role",role);
        List<Permission> pmList = permissionService.queryAllPermission();
        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(pmList);
        model.addAttribute("j",json);

        String s = rolePermissionRelationService.queryPidByRoleId(code);

        if(s!=null&&!s.equals("")&&s.length()!=0){
            String[] ids = s.split(",");
            List<Permission> pmList2 = new ArrayList<>();
            Permission permission = null;
            for (String id1 : ids) {
                permission = permissionService.queryPermissionById(Integer.parseInt(id1));
                pmList2.add(permission);
            }
            String json2 = mapper.writeValueAsString(pmList2);
            model.addAttribute("json2",json2);
        }else{
            String s1 = "[]";
            String json2 = mapper.writeValueAsString(s1);
            model.addAttribute("json2",json2);
        }
        return "settings/qx/role/detail";
    }
    @RequestMapping("settings/qx/role/queryRPRByRoleId.do")
    @ResponseBody
    public  Object queryRPRByRoleId(String roleId){
        String s = rolePermissionRelationService.queryPidByRoleId(roleId);
        String[] ids = s.split(",");
        return ids;
    }
    @RequestMapping("settings/qx/role/assignPermission.do/{roleId}")
    @ResponseBody
    public  Object assignPermission(@PathVariable String roleId,String ids){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        RolePermissionRelation rpr = new RolePermissionRelation();
        rpr.setRoleId(roleId);
        rpr.setPermissionId(ids);
        try {
            rolePermissionRelationService.assignPermission(rpr);
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("系统忙，请稍后重试···");
        }
        return  returnInfoObject;
    }
    @RequestMapping("/settings/qx/user/editPwd.do")
    @ResponseBody
    public  Object editPwd(@RequestParam Map<String,Object> map){
        System.out.println(map);
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            int ret = userService.editPwdById(map);
            if(ret>0){
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
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
}
