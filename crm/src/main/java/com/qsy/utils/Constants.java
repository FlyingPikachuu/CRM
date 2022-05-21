package com.qsy.utils;

import org.junit.Test;

import java.sql.SQLOutput;

/**
 * @author qsy
 * @create 2022/3/29 - 11:06
 */
public class Constants {
    //保存ReturnObject类的code值
    public static final String RETURN_OBJECT_CODE_SUCCESS = "1";//成功
    public static final String RETURN_OBJECT_CODE_FAIL = "0";//失败

    //session中保存的当前用户的Key
    public static final String SESSION_USER = "userInfo";//
    //session中保存当前用户权限列表的Key
    public static final String SESSION_PERMISSION_LIST = "allPermissionList";
    public static final String SESSION_USER_PERMISSION_LIST = "userPermissionList";



    //保存备注修改标记
    public static final String RETURN_EDIT_FLAG_NO_EDITED="0";
    public static final String RETURN_EDIT_FLAG_HAVE_EDITED="1";
    //节点是否被选中
    public static final int RETURN_CHECKED_TRUE=1;
    public static final int RETURN_CHECKED_FALSE=0;
    //节点是否展开
    public static final int RETURN_NOT_OPEN=0;
    public static final int RETURN_OPEN=1;

    public static final String PERMISSION_DETAIL_URL="settings/qx/permission/queryPermissionById.do/";
    public static final String PERMISSION_DETAIL_TARGET="workAreaFrame2";
}

