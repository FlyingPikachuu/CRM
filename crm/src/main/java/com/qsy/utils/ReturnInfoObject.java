package com.qsy.utils;

import lombok.Data;

/**
 * @author qsy
 * @create 2022/3/29 - 12:09
 */
/*
* 返回响应给前端的信息*/
    @Data
public class ReturnInfoObject {
    private String code;//处理成功或失败的标记
    private String message;//提示信息
    private Object returnData;//返回的其他数据
}
